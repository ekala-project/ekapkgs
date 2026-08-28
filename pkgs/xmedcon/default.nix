{
  stdenv,
  lib,
  fetchurl,
  gtk3,
  glib,
  pkg-config,
  libpng,
  zlib,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmedcon";
  version = "0.26.2";

  src = fetchurl {
    url = "mirror://sourceforge/xmedcon/xmedcon-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-r0oDA5wMS2bkKCgM7C+WxUahGvJm7NUA/iUNu2uZJPE=";
  };

  buildInputs = [
    gtk3
    glib
    libpng
    zlib
  ];

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  meta = {
    description = "Open source toolkit for medical image conversion";
    homepage = "https://xmedcon.sourceforge.net/";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
  };
})
