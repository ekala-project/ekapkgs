{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "culmus";
  version = "0.140";

  src = fetchurl {
    url = "mirror://sourceforge/culmus/culmus/${version}/culmus-${version}.tar.gz";
    hash = "sha256-ba7RBEgQB3UqdpBQAOccAJPFkcjvMBfRsYIiwnf8UuM=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp -v *.ttf $out/share/fonts/truetype/
    cp -v *.otf $out/share/fonts/truetype/
    cp -v fonts.scale-ttf $out/share/fonts/truetype/fonts.scale

    runHook postInstall
  '';

  meta = {
    description = "Culmus Hebrew fonts";
    longDescription = "The Culmus project aims at providing the Hebrew-speaking GNU/Linux and Unix community with a basic collection of Hebrew fonts for X Windows.";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl2;
    homepage = "http://culmus.sourceforge.net/";
    downloadPage = "http://culmus.sourceforge.net/download.html";
  };
}
