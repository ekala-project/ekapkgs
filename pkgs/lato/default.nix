{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation {
  pname = "lato";
  version = "2.0";

  src = fetchzip {
    url = "https://www.latofonts.com/download/Lato2OFL.zip";
    stripRoot = false;
    hash = "sha256-n1TsqigCQIGqyGLGTjLtjHuBf/iCwRlnqh21IHfAuXI=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 Lato2OFL/*.ttf -t $out/share/fonts/lato

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.latofonts.com/";
    description = "Sans-serif typeface family designed in Summer 2010 by Lukasz Dziedzic";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
