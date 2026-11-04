{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  vala,
  glib,
  gtk4,
  libadwaita,
  libgee,
  pango,
  desktop-file-utils,
  gettext,
  itstool,
  libxml2,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swell-foop";
  version = "50.0";

  src = fetchurl {
    url = "mirror://gnome/sources/swell-foop/${lib.versions.major finalAttrs.version}/swell-foop-${finalAttrs.version}.tar.xz";
    hash = "sha256-lrJDAj4NSmb5hrwpaLDwuGYY4VpV+X6D/mqwCefngus=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    vala
    pkg-config
    gtk4.wrapGAppsHook
    python3
    itstool
    gettext
    libxml2
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libgee
    pango
  ];

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/swell-foop";
    description = "Puzzle game, previously known as Same GNOME";
    mainProgram = "swell-foop";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
