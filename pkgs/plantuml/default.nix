{
  lib,
  stdenvNoCC,
  fetchurl,
  graphviz,
  jdk,
  makeBinaryWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plantuml";
  version = "1.2026.3";

  src = fetchurl {
    url = "https://github.com/plantuml/plantuml/releases/download/v${finalAttrs.version}/plantuml-pdf-${finalAttrs.version}.jar";
    hash = "sha256-ElMmvC2H8NRYwcEY5oIqo7fsiKAJBZDNqRFXOv2o5IE=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  buildCommand = ''
    install -Dm644 $src $out/lib/plantuml.jar

    mkdir -p $out/bin
    makeWrapper ${jdk}/bin/java $out/bin/plantuml \
      --argv0 plantuml \
      --set GRAPHVIZ_DOT ${graphviz}/bin/dot \
      --add-flags "-jar $out/lib/plantuml.jar"
  '';

  meta = {
    description = "Draw UML diagrams using a simple and human readable text description";
    homepage = "https://plantuml.com/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "plantuml";
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
