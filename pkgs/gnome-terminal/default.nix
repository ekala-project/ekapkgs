{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  python3,
  libxml2, # TODO: not in ekapkgs, needs porting or corepkgs
  nautilus,
  glib,
  gtk4,
  gtk3,
  libhandy,
  gsettings-desktop-schemas,
  vte,
  gettext,
  which, # TODO: not in ekapkgs, needs porting or corepkgs
  libuuid, # TODO: not in ekapkgs, needs porting or corepkgs
  vala,
  desktop-file-utils,
  itstool,
  wrapGAppsHook3,
  pcre2, # TODO: not in ekapkgs, needs porting or corepkgs
  libxslt, # TODO: not in ekapkgs, needs porting or corepkgs
  docbook-xsl-nons, # TODO: not in ekapkgs, needs porting or corepkgs
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-terminal";
  version = "3.60.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-terminal/${lib.versions.majorMinor finalAttrs.version}/gnome-terminal-${finalAttrs.version}.tar.xz";
    hash = "sha256-uNrz8IVFFyxNKIVzP3IDYasDSepmm5kkXu1K0W7T3ig=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
    which
    libxml2
    libxslt
    glib # for glib-compile-schemas
    docbook-xsl-nons
    vala
    desktop-file-utils
    wrapGAppsHook3
    python3
  ];

  buildInputs = [
    glib
    gtk4
    gtk3
    libhandy
    gsettings-desktop-schemas
    vte
    libuuid
    nautilus # For extension
    pcre2
  ];

  postPatch = ''
    patchShebangs \
      data/icons/meson_updateiconcache.py \
      data/meson_desktopfile.py \
      data/meson_metainfofile.py \
      src/meson_compileschemas.py
  '';

  meta = {
    description = "GNOME Terminal Emulator";
    mainProgram = "gnome-terminal";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-terminal";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
  };
})
