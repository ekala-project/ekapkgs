{
  lib,
  stdenv,
  fetchurl,
  desktop-file-utils,
  gettext,
  glibcLocales,
  itstool,
  libxml2,
  meson,
  ninja,
  pkg-config,
  python3,
  wrapGAppsHook4,
  cpio,
  glib,
  gtk4,
  libadwaita,
  json-glib,
  libarchive,
  nautilus ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "file-roller";
  version = "44.7";

  src = fetchurl {
    url = "mirror://gnome/sources/file-roller/${lib.versions.major finalAttrs.version}/file-roller-${finalAttrs.version}.tar.xz";
    hash = "sha256-Z8ralqJAnIWfN46C++hosOnACmnmt7iF1ULGTqKhKX0=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    glibcLocales
    itstool
    libxml2
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
    wrapGAppsHook4
  ];

  buildInputs = [
    cpio
    glib
    gtk4
    libadwaita
    json-glib
    libarchive
  ]
  ++ lib.optional (nautilus != null) nautilus;

  mesonFlags = lib.optionals (nautilus == null) [
    "-Dnautilus-actions=disabled"
  ];

  postPatch = ''
    patchShebangs data/set-mime-type-entry.py
  '';

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/file-roller";
    changelog = "https://gitlab.gnome.org/GNOME/file-roller/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Archive manager for the GNOME desktop environment";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "file-roller";
  };
})
