{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  gi-docgen,
  meson,
  ninja,
  desktop-file-utils,
  gettext,
  itstool,
  gtk4,
  libadwaita,
  glib,
  at-spi2-core,
  gobject-introspection,
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ghex";
  version = "50.2";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/ghex/${lib.versions.major finalAttrs.version}/ghex-${finalAttrs.version}.tar.xz";
    hash = "sha256-QTTSMYsqqtx6s90z4H1+bb8xZjzvW/0tIbqQ3tX1hKs=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    itstool
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gi-docgen
    gobject-introspection
    vala
    gtk4.wrapGAppsHook
  ];

  buildInputs = [
    gtk4
    libadwaita
    at-spi2-core
    glib
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dvapi=true"
  ];

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/ghex";
    changelog = "https://gitlab.gnome.org/GNOME/ghex/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Hex editor for GNOME desktop environment";
    mainProgram = "ghex";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
})
