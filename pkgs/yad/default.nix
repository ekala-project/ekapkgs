{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  intltool,
  autoreconfHook,
  wrapGAppsHook3,
  gtk3,
  hicolor-icon-theme,
  netpbm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yad";
  version = "14.1";

  src = fetchFromGitHub {
    owner = "v1cont";
    repo = "yad";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Y7bp20fkNdSgBcSV1kPEpWEP7ASwZcScVRaPauwI72M=";
  };

  patches = [ ./gettext-0.25.patch ];

  configureFlags = [
    "--enable-icon-browser"
    "--with-gtk=gtk3"
    "--with-rgb=${placeholder "out"}/share/yad/rgb.txt"
  ];

  buildInputs = [
    gtk3
    hicolor-icon-theme
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    intltool
    wrapGAppsHook3
  ];

  postPatch = ''
    sed -i src/file.c -e '21i#include <glib/gprintf.h>'
    sed -i src/form.c -e '21i#include <stdlib.h>'

    install -Dm644 ${netpbm.out}/share/netpbm/misc/rgb.txt $out/share/yad/rgb.txt
  '';

  postAutoreconf = ''
    intltoolize
  '';

  meta = {
    homepage = "https://github.com/v1cont/yad";
    description = "GUI dialog tool for shell scripts";
    license = lib.licenses.gpl3;
    mainProgram = "yad";
    platforms = lib.platforms.linux;
  };
})
