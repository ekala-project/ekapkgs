{
  lib,
  fetchurl,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  pname = "carlito";
  version = "20130920";

  src = fetchurl {
    url = "https://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/crosextrafonts-carlito-${version}.tar.gz";
    sha256 = "sha256-S9ErbLwyHBzxbaduLFhcklzpVqCAZ65vbGTv9sz9r1o=";
  };

  installPhase = ''
    mkdir -p $out/etc/fonts/conf.d
    mkdir -p $out/share/fonts/truetype
    cp -v *.ttf $out/share/fonts/truetype
    cp -v ${./calibri-alias.conf} $out/etc/fonts/conf.d/30-calibri.conf
  '';

  meta = {
    homepage = "http://openfontlibrary.org/en/font/carlito";
    description = "Sans-serif font metric-compatible with Microsoft Calibri";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    priority = 10;
  };
}
