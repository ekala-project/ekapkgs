{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libemf";
  version = "1.0.13";

  src = fetchurl {
    url = "mirror://sourceforge/libemf/libemf-${finalAttrs.version}.tar.gz";
    hash = "sha256-dNksAX6L60FzCovgfCxuT/ZUdmDIS/kfgy2PMl3Qz4I=";
  };

  meta = {
    description = "Library for generating Enhanced Metafile Format files";
    homepage = "https://sourceforge.net/projects/libemf/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
