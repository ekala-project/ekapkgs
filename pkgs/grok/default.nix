{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  autoPatchelfHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  version = "1.0.46";

  platformMap = {
    x86_64-linux = "linux-x86_64";
    aarch64-linux = "linux-aarch64";
    aarch64-darwin = "macos-aarch64";
  };
  platform =
    platformMap.${stdenv.hostPlatform.system}
      or (throw "Unsupported system for grok: ${stdenv.hostPlatform.system}");

  hashes = {
    x86_64-linux = "sha256-QWJqUykjJBQLklVrnUL/VULj3NBK/4Xq+4aJ3UrbRPw=";
    aarch64-linux = "sha256-RbCUPnNvAKJJuc8Cryvp4HSdl8Cab1XPzzApoag28j4=";
    aarch64-darwin = "sha256-6NqjAjZMnDtqVUbVEc+9GrXl1AepsEKC9mBmXqQF+fM=";
  };
in
stdenv.mkDerivation {
  pname = "grok";
  inherit version;

  src = fetchurl {
    url = "https://storage.googleapis.com/grok-build-public-artifacts/cli/grok-${version}-${platform}";
    hash = hashes.${stdenv.hostPlatform.system};
  };

  dontUnpack = true;
  dontStrip = true;

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  autoPatchelfIgnoreMissingDeps = [ "liblttng-ust.so.0" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 $src $out/libexec/grok/grok

    makeWrapper $out/libexec/grok/grok $out/libexec/grok/grok-launcher \
      --argv0 grok \
      --set GROK_DISABLE_AUTOUPDATER 1

    makeWrapper $out/libexec/grok/grok $out/libexec/grok/agent-launcher \
      --argv0 agent \
      --set GROK_DISABLE_AUTOUPDATER 1

    mkdir -p $out/bin
    ln -s $out/libexec/grok/grok-launcher $out/bin/grok
    ln -s $out/libexec/grok/agent-launcher $out/bin/agent

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Grok CLI - xAI's coding agent for the terminal";
    homepage = "https://github.com/xai-org/grok-cli";
    changelog = "https://github.com/xai-org/grok-cli/releases/tag/v${version}";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "grok";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
