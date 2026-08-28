{
  lib,
  stdenv,
  buildPackages,
  fetchurl,
  installShellFiles,
  autoPatchelfHook,
  zstd,
}:

let
  buildHashes = builtins.fromJSON (builtins.readFile ./hashes.json);
  archHashes = buildHashes.${stdenv.hostPlatform.system};

  platform-suffix =
    {
      aarch64-darwin = "aarch64-apple-darwin";
      x86_64-linux = "x86_64-unknown-linux-gnu";
      aarch64-linux = "aarch64-unknown-linux-gnu";
    }
    .${stdenv.hostPlatform.system};
in
stdenv.mkDerivation (finalAttrs: {
  pname = "buck2";
  version = buildHashes.version;

  srcs = [
    (fetchurl {
      url = "https://github.com/facebook/buck2/releases/download/${finalAttrs.version}/buck2-${platform-suffix}.zst";
      hash = archHashes.buck2;
    })
    (fetchurl {
      url = "https://github.com/facebook/buck2/releases/download/${finalAttrs.version}/rust-project-${platform-suffix}.zst";
      hash = archHashes.rust-project;
    })
  ];

  unpackCmd = "unzstd $curSrc -o $(stripHash $curSrc)";
  sourceRoot = ".";

  strictDeps = true;
  nativeBuildInputs = [
    installShellFiles
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.libgcc or null
  ];

  installPhase = ''
    runHook preInstall

    install -D buck2* "$out/bin/buck2"
    install -D rust-project* "$out/bin/rust-project"

    runHook postInstall
  '';

  preInstallCheck =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
      installShellCompletion --cmd buck2 \
        --bash <(${emulator} $out/bin/buck2 completion bash ) \
        --fish <(${emulator} $out/bin/buck2 completion fish ) \
        --zsh <(${emulator} $out/bin/buck2 completion zsh )
    '';

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preVersionCheck = "version=buck2";

  passthru = {
    prelude = fetchurl {
      url = "https://github.com/facebook/buck2-prelude/archive/${buildHashes.preludeGit}.tar.gz";
      hash = buildHashes.preludeFod;
    };
  };

  meta = {
    description = "Fast, hermetic, multi-language build system";
    homepage = "https://buck2.build";
    changelog = "https://github.com/facebook/buck2/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "buck2";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
