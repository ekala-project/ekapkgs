{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk3,
  autoconf,
  autoconf-archive,
  automake,
  gettext,
  intltool,
  libtool,
  pkg-config,
  libice,
  libsm,
  libxscrnsaver,
  libxtst,
  gobject-introspection,
  glib,
  glibmm_2_4,
  gtkmm3,
  at-spi2-core,
  pango,
  pangomm,
  cairo,
  cairomm_1_0,
  dbus,
  dbus-glib,
  gstreamer,
  libsigcxx_2_0,
  boost,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "workrave";
  version = "1.10.54";

  src = fetchFromGitHub {
    repo = "workrave";
    owner = "rcaelers";
    rev = "v" + lib.concatStringsSep "_" (lib.splitVersion finalAttrs.version);
    sha256 = "sha256-pbMkzwxgKc4vjFhBeOf513hFytYiTPST19L8Nq4CVTg=";
  };

  nativeBuildInputs = [
    autoconf
    autoconf-archive
    automake
    gettext
    intltool
    libtool
    pkg-config
    gtk3.wrapGAppsHook
    python3Packages.jinja2
    gobject-introspection
  ];

  buildInputs = [
    libice
    libsm
    libxscrnsaver
    libxtst
    glib
    glibmm_2_4
    gtkmm3
    at-spi2-core
    pango
    pangomm
    cairo
    cairomm_1_0
    dbus
    dbus-glib
    gstreamer
    gstreamer.plugins-base
    gstreamer.plugins-good
    libsigcxx_2_0
    boost
  ];

  preConfigure = "./autogen.sh";

  enableParallelBuilding = true;

  meta = {
    description = "Program to help prevent Repetitive Strain Injury";
    mainProgram = "workrave";
    homepage = "http://www.workrave.org/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
})
