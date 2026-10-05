{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  version = "7.8.1";

  platformMap = {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
  };

  system = stdenv.hostPlatform.system;
  platform = platformMap.${system} or (throw "kilocode-cli: unsupported system ${system}");

  hashes = {
    x86_64-linux = "sha256-bUIjNVvwaxK1xaHo9z3K0bgs/DGcD+k7AHgpkZ8Fb8U=";
    aarch64-linux = "sha256-SPz0jffn5ujo0pP1KU2SXjKMcSZKmo9cq9iI1GLjozA=";
    aarch64-darwin = "sha256-SOl3fU6HurL8lBWJ9/iIfBWBXuqBtgCVuFoqvidlTYA=";
  };
in
stdenv.mkDerivation {
  pname = "kilocode-cli";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/@kilocode/cli-${platform}/-/cli-${platform}-${version}.tgz";
    hash = hashes.${system};
  };

  sourceRoot = "package";

  nativeBuildInputs = [ makeWrapper ] ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  dontBuild = true;
  # bun-compiled binary: stripping corrupts the embedded bytecode.
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/kilo $out/bin/kilocode
    mkdir -p $out/bin/tree-sitter
    cp -r bin/tree-sitter/. $out/bin/tree-sitter/
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Open-source AI coding agent for your terminal";
    homepage = "https://kilocode.ai/cli";
    changelog = "https://github.com/Kilo-Org/kilocode/releases";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    mainProgram = "kilocode";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
