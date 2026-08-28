{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  glib,
  sqlite,
  gdk-pixbuf,
  gobject-introspection,
}:

stdenv.mkDerivation rec {
  pname = "gom";
  version = "0.5.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gom/${lib.versions.majorMinor version}/gom-${version}.tar.xz";
    sha256 = "Bp0JCfvca00n7feoeTZhlOOrUIsDVIv1uJ/2NUbSAXc=";
  };

  patches = [
    ./longer-stress-timeout.patch
  ];

  nativeBuildInputs = [
    gobject-introspection
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    sqlite
  ];

  mesonFlags = [
    "-Denable-introspection=false"
    "-Dpygobject-override-dir="
  ];

  doCheck = stdenv.hostPlatform.isx86_64;

  meta = {
    description = "GObject to SQLite object mapper";
    homepage = "https://gitlab.gnome.org/GNOME/gom";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
}
