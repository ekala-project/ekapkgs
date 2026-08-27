{
  stdenv,
  lib,
  fetchurl,
  at-spi2-core,
  babl,
  dbus,
  desktop-file-utils,
  dleyna ? null, # TODO: not in ekapkgs, needs porting
  gdk-pixbuf,
  gegl,
  geocode-glib_2,
  gettext,
  gexiv2,
  glib,
  gnome-online-accounts, # TODO: being ported to ekapkgs
  gobject-introspection,
  gsettings-desktop-schemas,
  gtk3,
  itstool,
  libdazzle,
  libportal-gtk3 ? null, # TODO: not in ekapkgs, needs porting
  libhandy,
  libxml2,
  meson,
  ninja,
  pkg-config,
  python3,
  tinysparql, # TODO: being ported to ekapkgs
  localsearch,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "gnome-photos";
  version = "44.0";

  outputs = [
    "out"
    "installedTests"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-photos/${lib.versions.major version}/gnome-photos-${version}.tar.xz";
    sha256 = "544hA5fTxigJxs1VIdpuzLShHd6lvyr4YypH9Npcgp4=";
  };

  patches = [
    ./installed-tests-path.patch
  ];

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    gobject-introspection # for setup hook
    glib # for setup hook
    itstool
    libxml2
    meson
    ninja
    pkg-config
    (python3.withPackages (
      pkgs: lib.filter (p: p != null) [
        (pkgs.dogtail or null)
        (pkgs.pygobject3 or null)
        (pkgs.pyatspi or null)
      ]
    ))
    wrapGAppsHook3
  ];

  buildInputs = [
    babl
    dbus
  ] ++ lib.optional (dleyna != null) dleyna ++ [
    gdk-pixbuf
    gegl
    geocode-glib_2
    gexiv2
    glib
    gnome-online-accounts
    gsettings-desktop-schemas
    gtk3
    libdazzle
  ] ++ lib.optional (libportal-gtk3 != null) libportal-gtk3 ++ [
    libhandy
    tinysparql
    localsearch # For 'org.freedesktop.Tracker.Miner.Files' GSettings schema

    at-spi2-core # for tests
  ];

  mesonFlags = [
    "-Dinstalled_tests=true"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
    patchShebangs tests/basic.py
  '';

  postFixup = ''
    wrapGApp "${placeholder "installedTests"}/libexec/installed-tests/gnome-photos/basic.py"
  '';

  meta = {
    description = "Access, organize and share your photos";
    mainProgram = "gnome-photos";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-photos";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
