{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  glib,
  dbus,
  libxml2,
  gobject-introspection,
  libXtst,
  libXi,
  libXext,
  libX11,
  systemd,
  gettext,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "at-spi2-core";
  version = "2.54.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/at-spi2-core/${lib.versions.majorMinor version}/at-spi2-core-${version}.tar.xz";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    gettext
    python3
  ];

  buildInputs = [
    glib
    dbus
    libxml2
    libXtst
    libXi
    libXext
    libX11
    systemd
  ];

  mesonFlags = [
    "-Dsystemd_user_dir=${placeholder "out"}/lib/systemd/user"
    "-Ddbus_daemon=/run/current-system/sw/bin/dbus-daemon"
  ];

  meta = {
    description = "D-Bus accessibility specifications and registration daemon";
    homepage = "https://wiki.gnome.org/Accessibility";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
