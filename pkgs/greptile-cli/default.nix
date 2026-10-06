{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  nodejs,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  version = "3.6.0";

  hashes = {
    x86_64-linux = "sha256-7RR/f0BpzY4NfeTndpTCFIgvDCaTxf4wtBljBBALm+A=";
    aarch64-linux = "sha256-7RR/f0BpzY4NfeTndpTCFIgvDCaTxf4wtBljBBALm+A=";
    aarch64-darwin = "sha256-7RR/f0BpzY4NfeTndpTCFIgvDCaTxf4wtBljBBALm+A=";
  };
in
stdenv.mkDerivation {
  pname = "greptile-cli";
  inherit version;

  src = fetchurl {
    url = "https://github.com/greptileai/cli/releases/download/v${version}/greptile.js";
    hash = hashes.${stdenv.hostPlatform.system};
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm644 $src $out/libexec/greptile.js
    makeWrapper ${lib.getExe nodejs} $out/bin/greptile \
      --add-flags $out/libexec/greptile.js
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "Greptile CLI for AI-powered code review";
    homepage = "https://github.com/greptileai/cli";
    changelog = "https://github.com/greptileai/cli/releases/tag/v${version}";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    mainProgram = "greptile";
    platforms = lib.platforms.all;
  };
}
