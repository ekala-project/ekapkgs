{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  glib,
  cairo,
  libarchive,
  freetype,
  libjpeg,
  libtiff,
  lcms2,
}:

stdenv.mkDerivation rec {
  pname = "libgxps";
  version = "0.3.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "bSeGclajXM+baSU+sqiKMrrKO5fV9O9/guNmf6Q1JRw=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    glib
    cairo
    freetype
    libjpeg
    libtiff
    lcms2
  ];

  propagatedBuildInputs = [ libarchive ];

  mesonFlags = [
    "-Denable-test=false"
    "-Ddisable-introspection=true"
  ];

  meta = {
    description = "GObject based library for handling and rendering XPS documents";
    homepage = "https://gitlab.gnome.org/GNOME/libgxps";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
}
