{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  jre,
  makeWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "saxon";
  version = "12.10";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/Saxonica/Saxon-HE/SaxonHE12-10/12/Java/SaxonHE12-10J.zip";
    hash = "sha256-HH259ybfg1NJxk7dYx3gMQ7KMSkRACMAZOuhU/YHsL4=";
  };

  nativeBuildInputs = [
    unzip
    makeWrapper
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out/share/java/ *.jar
    mv doc $out/share
    mv lib $out/share/java

    mkdir -p $out/bin
    makeWrapper ${lib.getExe jre} $out/bin/saxon-he \
      --add-flags "-jar $out/share/java/saxon-he-${finalAttrs.version}.jar"

    ln -s $out/bin/saxon-he $out/bin/saxon-he-xslt

    makeWrapper ${lib.getExe jre} $out/bin/transform \
      --add-flags "-cp $out/share/java/saxon-he-${finalAttrs.version}.jar net.sf.saxon.Transform"

    makeWrapper ${lib.getExe jre} $out/bin/query \
      --add-flags "-cp $out/share/java/saxon-he-${finalAttrs.version}.jar net.sf.saxon.Query"

    runHook postInstall
  '';

  meta = {
    description = "Processor for XSLT 3.0, XPath 3.1, and XQuery 3.1";
    homepage = "https://www.saxonica.com/products/latest.xml";
    license = lib.licenses.mpl20;
    mainProgram = "saxon-he";
    platforms = lib.platforms.all;
  };
})
