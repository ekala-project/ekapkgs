{
  lib,
  stdenv,
  meson,
  fetchurl,
  python3,
  pkg-config,
  gtk4,
  glib,
  gtksourceview5,
  gsettings-desktop-schemas,
  wrapGAppsHook4,
  ninja,
  icu,
  itstool,
  libadwaita,
  libspelling,
  editorconfig-core-c,
  libxml2,
  desktop-file-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-text-editor";
  version = "50.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-text-editor/${lib.versions.major finalAttrs.version}/gnome-text-editor-${finalAttrs.version}.tar.xz";
    hash = "sha256-9oA2sJ03j6qIO/6Tbkecb/NwJ8L/7RAdr5Et9wxR0OY=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    itstool
    libxml2 # for xmllint
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
    wrapGAppsHook4
  ];

  buildInputs = [
    icu
    glib
    gsettings-desktop-schemas
    gtk4
    gtksourceview5
    libadwaita
    libspelling
    editorconfig-core-c
  ];

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-text-editor";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-text-editor/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Text Editor for GNOME";
    mainProgram = "gnome-text-editor";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
