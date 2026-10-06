{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  installShellFiles,
  makeWrapper,
  rustPlatform,
  pkg-config,
  lld,
  openssl,
  bubblewrap,
  libcap,
  versionCheckHook,
}:

let
  versionData = builtins.fromJSON (builtins.readFile ./hashes.json);

  mkRustyV8Archive = import ./rusty-v8.nix {
    inherit lib stdenv fetchurl;
  };
  librusty_v8 = mkRustyV8Archive versionData.librusty_v8;

  src = fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    tag = "rust-v${versionData.version}";
    inherit (versionData) hash;
  };
in
rustPlatform.buildRustPackage {
  pname = "codex";
  version = versionData.version;
  inherit src;
  sourceRoot = "${src.name}/codex-rs";

  cargoHash = versionData.cargoHash;

  cargoBuildFlags = [
    "--package"
    "codex-cli"
    "--package"
    "codex-code-mode-host"
  ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    rustPlatform.bindgenHook
  ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isLinux [ libcap ];

  env = {
    RUSTY_V8_ARCHIVE = librusty_v8;
  }
  // lib.optionalAttrs (librusty_v8 ? srcBinding) {
    RUSTY_V8_SRC_BINDING_PATH = librusty_v8.srcBinding;
  }
  // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_CFLAGS_LINK = "-fuse-ld=${lib.getExe' lld "ld64.lld"}";
  };

  postPatch = ''
    if ! grep -q 'recursion_limit' chatgpt/src/lib.rs; then
      substituteInPlace chatgpt/src/lib.rs \
        --replace-fail 'pub mod apply_command;' \
        $'#![recursion_limit = "256"]\n\npub mod apply_command;'
    fi
  '';

  preBuild = ''
    substituteInPlace Cargo.toml \
      --replace-fail 'lto = "thin"' "" \
      --replace-fail 'codegen-units = 4' "" \
      --replace-fail 'debug = "line-tables-only"' 'debug = "none"'
    if [ "$NIX_BUILD_CORES" -gt 8 ]; then
      export NIX_BUILD_CORES=8
    fi
  '';

  doCheck = false;

  # codex looks for codex-resources/bwrap and codex-code-mode-host next to
  # its own executable, so the real binaries live together in libexec/.
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/libexec/codex/bin $out/libexec/codex/codex-resources
    ln -s ${lib.getExe bubblewrap} $out/libexec/codex/codex-resources/bwrap
    mv $out/bin/codex $out/bin/codex-code-mode-host $out/bin/logs_client \
      $out/libexec/codex/bin/

    makeWrapper $out/libexec/codex/bin/codex $out/bin/codex \
      --prefix PATH : ${lib.makeBinPath [ bubblewrap ]}
    ln -s ../libexec/codex/bin/codex-code-mode-host $out/bin/codex-code-mode-host
    ln -s ../libexec/codex/bin/logs_client $out/bin/logs_client
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd codex \
      --bash <($out/bin/codex completion bash) \
      --fish <($out/bin/codex completion fish) \
      --zsh <($out/bin/codex completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "OpenAI Codex CLI - a coding agent that runs locally on your computer";
    homepage = "https://github.com/openai/codex";
    changelog = "https://github.com/openai/codex/releases/tag/rust-v${versionData.version}";
    sourceProvenance = [
      lib.sourceTypes.fromSource
      lib.sourceTypes.binaryNativeCode
    ];
    license = lib.licenses.asl20;
    mainProgram = "codex";
    platforms = lib.platforms.unix;
  };
}
