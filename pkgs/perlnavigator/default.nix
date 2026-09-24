# perlnavigator — Language server for Perl (pre-built binary)
{
  stdenv,
  lib,
  fetchurl,
  unzip,
  autoPatchelfHook,
}:

let
  version = "0.8.20";

  sources = {
    x86_64-linux = {
      url = "https://github.com/bscan/PerlNavigator/releases/download/v${version}/perlnavigator-linux-x86_64.zip";
      hash = "sha256-WinIppGcMsa0fwWrHtOPYv/6VuwXUrjp1iReF3ujLNI=";
    };
  };
in
stdenv.mkDerivation {
  pname = "perlnavigator";
  inherit version;

  src = fetchurl (
    sources.${stdenv.hostPlatform.system}
      or (throw "perlnavigator: unsupported platform ${stdenv.hostPlatform.system}")
  );

  nativeBuildInputs = [
    unzip
  ]
  ++ lib.optionals stdenv.hostPlatform.isElf [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isElf [ (lib.getLib stdenv.cc.cc) ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -m755 -D perlnavigator-linux-x86_64/perlnavigator $out/bin/perlnavigator
    runHook postInstall
  '';

  meta = {
    description = "Language server for Perl";
    homepage = "https://github.com/bscan/PerlNavigator";
    license = lib.licenses.mit;
    platforms = builtins.attrNames sources;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "perlnavigator";
  };
}
