{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  desktop-file-utils,
  gtk3,
  libpng,
  exiv2,
  lcms,
  intltool,
  gettext,
  shared-mime-info,
  glib,
  gdk-pixbuf,
  perl,
  wrapGAppsHook3,
}:

stdenv.mkDerivation {
  pname = "viewnior-gtk3";
  version = "1.8-unstable-2023-11-23";

  src = fetchFromGitHub {
    owner = "Artturin";
    repo = "Viewnior";
    rev = "23ce6e5630b24509d8009f17a833ad9e59b85fab";
    hash = "sha256-+/f0+og1Dd7eJK7P83+q4lf4SjzW2g6qNk8ZTxNAuDA=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    desktop-file-utils
    intltool
    gettext
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libpng
    exiv2
    lcms
    shared-mime-info
    glib
    gdk-pixbuf
    perl
  ];

  meta = {
    description = "Fast and simple image viewer";
    license = lib.licenses.gpl3;
    homepage = "https://siyanpanayotov.com/project/viewnior/";
    platforms = lib.platforms.linux;
    mainProgram = "viewnior";
  };
}
