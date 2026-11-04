{
  stdenv,
  lib,
  desktop-file-utils,
  fetchurl,
  glib,
  gettext,
  gtk4,
  libadwaita,
  libdex,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "d-spy";
  version = "50.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/d-spy/${lib.versions.major finalAttrs.version}/d-spy-${finalAttrs.version}.tar.xz";
    hash = "sha256-G93IbYos9ntPZS3EYczYNTES8Ih1NCADfHX1RU3qrRA=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    desktop-file-utils
    gtk4.wrapGAppsHook
    gettext
    glib
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libdex
  ];

  meta = {
    description = "D-Bus exploration tool";
    mainProgram = "d-spy";
    homepage = "https://gitlab.gnome.org/GNOME/d-spy";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
