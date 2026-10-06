{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  versionCheckHook,
}:

let
  version = "0.1.0-beta.5";

  platformMap = {
    x86_64-linux = "x86_64-unknown-linux-gnu";
    aarch64-linux = "aarch64-unknown-linux-gnu";
    aarch64-darwin = "aarch64-apple-darwin";
  };
  platform = platformMap.${stdenv.hostPlatform.system}
    or (throw "Unsupported system for tui-test: ${stdenv.hostPlatform.system}");

  hashes = {
    x86_64-linux = "sha256-R4hTnPMT/m0wsyHeW756yLWDDISyqm9oFTNWhtoZ3IM=";
    aarch64-linux = "sha256-VXqkHlhSBcCh19++F4aELmM2DZpMyyvXCW99SvJ1cGs=";
    aarch64-darwin = "sha256-T/mnLokclkPtHBJlEN75qPNIqgwg1TXXKDroMediI1o=";
  };
in
stdenv.mkDerivation {
  pname = "tui-test";
  inherit version;

  src = fetchurl {
    url = "https://github.com/microsoft/tui-test/releases/download/${version}/tui-test-${platform}.tar.gz";
    hash = hashes.${stdenv.hostPlatform.system};
  };

  sourceRoot = ".";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  autoPatchelfIgnoreMissingDeps = [ "liblttng-ust.so.0" ];

  installPhase = ''
    runHook preInstall
    install -Dm755 tui-test $out/bin/tui-test
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Control, inspect, test, and record any TUI app or CLI in a headless terminal";
    homepage = "https://github.com/microsoft/tui-test";
    changelog = "https://github.com/microsoft/tui-test/releases/tag/${version}";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "tui-test";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
