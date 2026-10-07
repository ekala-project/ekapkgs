{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gettext,
  gobject-introspection,
  glib,
  gtk3,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "libpeas";
  version = "1.38.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/libpeas/${lib.versions.majorMinor version}/libpeas-${version}.tar.xz";
    sha256 = "sha256-6C/TKK3KwaujS2QTa9/Lus8rMliovE5fSApyUCphGuk=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
    gettext
    gobject-introspection
    gtk3.wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    ncurses
  ];

  propagatedBuildInputs = [
    gobject-introspection
  ];

  mesonEntries = {
    gtk_doc = false;
    introspection = false;
    python3 = false;
  };

  meta = {
    description = "GObject-based plugins engine";
    mainProgram = "peas-demo";
    homepage = "https://gitlab.gnome.org/GNOME/libpeas";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
