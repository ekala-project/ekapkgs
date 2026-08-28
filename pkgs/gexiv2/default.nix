{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  exiv2,
  glib,
}:

stdenv.mkDerivation rec {
  pname = "gexiv2";
  version = "0.14.3";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "IeZNLFbpszPUT+8/KkslZT2SLEGazZcvqW+raVIX4sg=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    glib
  ];

  propagatedBuildInputs = [
    exiv2
  ];

  mesonFlags = [
    "-Dgtk_doc=false"
    "-Dintrospection=false"
    "-Dvapi=false"
    "-Dtests=false"
    "-Dpython3=false"
  ];

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gexiv2";
    description = "GObject wrapper around the Exiv2 photo metadata library";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
