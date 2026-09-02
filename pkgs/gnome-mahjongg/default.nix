{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  gtk4,
  wrapGAppsHook4,
  libadwaita,
  librsvg,
  gettext,
  itstool,
  libxml2,
  meson,
  ninja,
  glib,
  vala,
  desktop-file-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-mahjongg";
  version = "49.1.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-mahjongg/${lib.versions.major finalAttrs.version}/gnome-mahjongg-${finalAttrs.version}.tar.xz";
    hash = "sha256-6e3TGsJpi42aW+HRHGDUNFCoifh2nMoL7zOVoRpdX9E=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    desktop-file-utils
    pkg-config
    libxml2
    itstool
    gettext
    wrapGAppsHook4
    glib
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    librsvg
  ];

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-mahjongg";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-mahjongg/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Disassemble a pile of tiles by removing matching pairs";
    mainProgram = "gnome-mahjongg";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
