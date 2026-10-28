{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "docbook-dsssl";
  version = "1.79";

  src = fetchurl {
    url = "mirror://sourceforge/docbook/docbook-dsssl/${finalAttrs.version}/docbook-dsssl-${finalAttrs.version}.tar.bz2";
    hash = "sha256-LzKeEgvunvQvvddN3WDgXkl4bFp5U6D/TGgK5r3w4rw=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    dst=$out/share/sgml/docbook/dsssl-stylesheets-${finalAttrs.version}
    mkdir -p $dst
    cp -r . $dst/

    runHook postInstall
  '';

  meta = {
    description = "DSSSL stylesheets for DocBook";
    homepage = "https://docbook.sourceforge.net/";
    license = lib.licenses.free;
    platforms = lib.platforms.all;
  };
})
