{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  gtk3,
  gobject-introspection,
  json-glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtimezonemap";
  version = "0.4.6";

  src = fetchurl {
    url = "https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/libtimezonemap/${finalAttrs.version}-7build1/libtimezonemap_${finalAttrs.version}.orig.tar.gz";
    hash = "sha256-DWNMwkdtj1fR7hhkvU9EIYCuS/BAqa5L9ztmu9hdcZU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    json-glib
  ];

  meta = {
    description = "Library for displaying timezone maps";
    homepage = "https://launchpad.net/timezonemap";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
})
