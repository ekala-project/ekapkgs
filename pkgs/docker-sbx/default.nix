{
  lib,
  stdenvNoCC,
  fetchurl,
  installShellFiles,
  autoPatchelfHook,
  makeBinaryWrapper,
  e2fsprogs,
  lz4,
  xxhash,
  zlib,
  zstd,
  stdenv,
  versionCheckHook,
}:

let
  inherit (stdenvNoCC.hostPlatform) isLinux;

  version = "0.46.0";

  platformMap = {
    x86_64-linux = "linux-amd64";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin";
  };

  system = stdenvNoCC.hostPlatform.system;
  platform = platformMap.${system} or (throw "docker-sbx: unsupported system ${system}");

  hashes = {
    x86_64-linux = "sha256-7dhuLyFVnhkHI/2ITDodztFhpVWv3/hcWSHtRefW1W4=";
    aarch64-linux = "sha256-sg2i5eK6emcVGhmCGWDGV8CNj6jc/fXpdR8oTW5V/6g=";
    aarch64-darwin = "sha256-HaoHenk7wEjvaayzPLidJ84Glu+t9E32RmRj8qeditw=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "docker-sbx";
  inherit version;

  src = fetchurl {
    url = "https://github.com/docker/sbx-releases/releases/download/v${version}/DockerSandboxes-${platform}.tar.gz";
    hash = hashes.${system};
  };

  strictDeps = true;
  __structuredAttrs = true;

  # The darwin tarball has no top-level directory.
  sourceRoot = lib.optionalString (!isLinux) ".";

  # Preserve the upstream code signature; fixup could modify sealed files.
  dontFixup = !isLinux;

  nativeBuildInputs =
    [ installShellFiles ]
    ++ lib.optionals isLinux [
      autoPatchelfHook
      makeBinaryWrapper
    ];

  # mkfs.erofs and libsailor.so are dynamically linked.
  buildInputs = lib.optionals isLinux [
    stdenv.cc.cc.lib
    lz4
    xxhash
    zlib
    zstd
  ];

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString isLinux ''
    install -Dm755 -t $out/bin sbx
    install -Dm755 -t $out/libexec containerd-shim-nerdbox-* mkfs.erofs
    install -Dm644 -t $out/libexec nerdbox-kernel-* nerdbox-rootfs-*.erofs
    install -Dm755 -t $out/libexec/lib libsailor.so
    wrapProgram $out/bin/sbx --prefix PATH : ${lib.makeBinPath [ e2fsprogs ]}
  ''
  + lib.optionalString (!isLinux) ''
    mkdir -p $out/libexec $out/bin
    cp -a Sbx.app $out/libexec/docker-sbx
    ln -s $out/libexec/docker-sbx/Contents/MacOS/sbx $out/bin/sbx
    ln -s $out/libexec/docker-sbx/Contents/MacOS/llmman $out/bin/llmman
    installShellCompletion \
      --bash --name sbx.bash Sbx.app/Contents/Resources/completions/bash/sbx \
      --zsh --name _sbx Sbx.app/Contents/Resources/completions/zsh/_sbx \
      --fish --name sbx.fish Sbx.app/Contents/Resources/completions/fish/sbx.fish
  ''
  + ''
    runHook postInstall
  '';

  # sbx writes state under $HOME even for `completion` and `version`.
  postInstall =
    lib.optionalString (isLinux && stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform)
      ''
        export HOME=$TMPDIR
        installShellCompletion --cmd sbx \
          --bash <($out/bin/sbx completion bash) \
          --zsh <($out/bin/sbx completion zsh) \
          --fish <($out/bin/sbx completion fish)
      '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";
  versionCheckKeepEnvironment = [ "HOME" ];
  preVersionCheck = "export HOME=$TMPDIR";

  meta = {
    description = "Docker Sandboxes: run coding agents in microVMs with controlled filesystem and network access";
    homepage = "https://docs.docker.com/ai/sandboxes/";
    changelog = "https://github.com/docker/sbx-releases/releases/tag/v${version}";
    mainProgram = "sbx";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
