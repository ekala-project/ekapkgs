{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  extra-cmake-modules,
  fcitx5,
  gobject-introspection,
  glib,
  gtk2,
  gtk3,
  fmt,
  libuuid,
  libselinux,
  libsepol,
  libthai,
  libdatrie,
  libxdmcp,
  libxkbcommon,
  libepoxy,
  dbus,
  at-spi2-core,
  libxtst,
  withGTK2 ? false,
  # TODO(ekapkgs): Port gtk4 for GTK4 input method module support
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-gtk";
  version = "5.1.7";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-ddXMkk1pQhFCOSzDbRWi/VDWtxqqKhMM4AnVFBGCOyA=";
  };

  outputs = [
    "out"
    "dev"
  ];

  cmakeFlags = [
    "-DGOBJECT_INTROSPECTION_GIRDIR=share/gir-1.0"
    "-DGOBJECT_INTROSPECTION_TYPELIBDIR=lib/girepository-1.0"
    "-DENABLE_GTK4_IM_MODULE=off"
  ]
  ++ lib.optional (!withGTK2) "-DENABLE_GTK2_IM_MODULE=off";

  buildInputs = [
    glib
    gtk3
    fmt
    fcitx5
    libuuid
    libselinux
    libsepol
    libthai
    libdatrie
    libxdmcp
    libxkbcommon
    libepoxy
    dbus
    at-spi2-core
    libxtst
  ]
  ++ lib.optional withGTK2 gtk2;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    extra-cmake-modules
    gobject-introspection
  ];

  meta = {
    description = "Fcitx5 gtk im module and glib based dbus client library";
    homepage = "https://github.com/fcitx/fcitx5-gtk";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
