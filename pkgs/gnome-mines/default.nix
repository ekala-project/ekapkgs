{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  vala,
  pkg-config,
  gtk4,
  libadwaita,
  wrapGAppsHook4,
  librsvg,
  gettext,
  itstool,
  libxml2,
  libgee,
  desktop-file-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-mines";
  version = "50.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-mines/${lib.versions.major finalAttrs.version}/gnome-mines-${finalAttrs.version}.tar.xz";
    hash = "sha256-nTpEEi0Er3h8ZKhp75DdVOp1AOW0i+RXxtZNmydz+58=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    gettext
    itstool
    libxml2
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    gtk4
    libadwaita
    librsvg
    libgee
  ];

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-mines";
    description = "Clear hidden mines from a minefield";
    mainProgram = "gnome-mines";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
  };
})
