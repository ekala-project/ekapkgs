{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "docbook-xml";
  version = "4.5";

  src = fetchurl {
    url = "https://www.oasis-open.org/docbook/xml/${finalAttrs.version}/docbook-xml-${finalAttrs.version}.zip";
    hash = "sha256-Tk4DeiuDyYxslIGDkNS90/bhD27GLdeRiFlOJhkNx7Q=";
  };

  strictDeps = true;

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/xml/dtd/docbook
    cp -r ent/ *.dtd *.mod *.cat catalog.xml $out/xml/dtd/docbook/

    runHook postInstall
  '';

  meta = {
    description = "DocBook XML DTDs for document authoring";
    homepage = "https://docbook.org/xml/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
