{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "kacst-fonts";
  version = "2.01";

  src = fetchurl {
    url = "mirror://debian/pool/main/f/fonts-kacst/fonts-kacst_${version}+mry.orig.tar.bz2";
    hash = "sha256-byiZzpYiMU6kJs+NSISfHPFzAnJtc8toNIbV/fKiMzg=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts
    cp -R kacst $out/share/fonts

    runHook postInstall
  '';

  meta = {
    description = "Latin-Arabic TrueType fonts";
    homepage = "https://www.arabeyes.org/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
  };
}
