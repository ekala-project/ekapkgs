{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  gettext,
  glib,
  intltool,
  pkg-config,
  gtk2,
  libjpeg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpicview";
  version = "0.2.5";

  src = fetchurl {
    url = "mirror://sourceforge/lxde/gpicview-${finalAttrs.version}.tar.xz";
    hash = "sha256-OEZgWOU3AkUOWJkZPEsmQzmVm1Y91c2B9vaQ3jLYKUI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
    glib
    intltool
    pkg-config
  ];

  buildInputs = [
    gtk2
    libjpeg
  ];

  meta = {
    description = "Lightweight image viewer from the LXDE project";
    homepage = "https://lxde.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "gpicview";
  };
})
