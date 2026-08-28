{
  lib,
  stdenv,
  ladspa-sdk,
}:

stdenv.mkDerivation {
  pname = "ladspa-header";

  inherit (ladspa-sdk) version src;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/include
    cp src/ladspa.h $out/include/ladspa.h
  '';

  meta = {
    description = "LADSPA format audio plugins header file";
    homepage = "https://www.ladspa.org/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.all;
  };
}
