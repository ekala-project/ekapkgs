# nimlangserver — Language server for Nim (pre-built binary)
{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "1.14.0";

  sources = {
    x86_64-linux = {
      url = "https://github.com/nim-lang/langserver/releases/download/v${version}/nimlangserver-linux-amd64.tar.gz";
      hash = "sha256-RXDTK6++NVhByjyvujPc1ggN3F1dH6797YlsEW2XouU=";
    };
    aarch64-linux = {
      url = "https://github.com/nim-lang/langserver/releases/download/v${version}/nimlangserver-linux-arm64.tar.gz";
      hash = "sha256-ESW6do6mQPT5aJlLiQTqd3vnduCB0RQd9HCynx8itk0=";
    };
  };
in
stdenv.mkDerivation {
  pname = "nimlangserver";
  inherit version;

  src = fetchurl (
    sources.${stdenv.hostPlatform.system}
      or (throw "nimlangserver: unsupported platform ${stdenv.hostPlatform.system}")
  );

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isElf [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isElf [ (lib.getLib stdenv.cc.cc) ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -m755 -D nimlangserver $out/bin/nimlangserver
    runHook postInstall
  '';

  meta = {
    description = "Language server for Nim";
    homepage = "https://github.com/nim-lang/langserver";
    license = lib.licenses.mit;
    platforms = builtins.attrNames sources;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "nimlangserver";
  };
}
