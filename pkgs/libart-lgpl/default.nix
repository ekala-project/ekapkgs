{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libart-lgpl";
  version = "2.3.21";

  src = fetchurl {
    url = "mirror://gnome/sources/libart_lgpl/2.3/libart_lgpl-${finalAttrs.version}.tar.bz2";
    hash = "sha256-/cEedMEPyf/kGIU34rNwwKusyn2JAh1NMDr99/10dvo=";
  };

  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "Library for high-performance 2D graphics";
    homepage = "https://download.gnome.org/sources/libart_lgpl/";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
})
