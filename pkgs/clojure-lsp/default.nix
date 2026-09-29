# clojure-lsp — Language server for Clojure (standalone JAR)
{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  java,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clojure-lsp";
  version = "2026.07.06-14.34.19";

  src = fetchurl {
    url = "https://github.com/clojure-lsp/clojure-lsp/releases/download/${finalAttrs.version}/clojure-lsp-standalone.jar";
    hash = "sha256-GU92OeKzKm42Qy+6fMSpsSj0WInSrQVyVVFSPxZNaEY=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib
    install -m644 $src $out/lib/clojure-lsp-standalone.jar
    makeWrapper ${java}/bin/java $out/bin/clojure-lsp \
      --add-flags "-jar $out/lib/clojure-lsp-standalone.jar"
    runHook postInstall
  '';

  meta = {
    description = "Language server for Clojure";
    homepage = "https://clojure-lsp.io/";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    mainProgram = "clojure-lsp";
  };
})
