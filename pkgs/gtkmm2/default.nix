{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gtk2,
  glibmm,
  cairomm,
  pangomm,
  atkmm,
}:

stdenv.mkDerivation rec {
  pname = "gtkmm";
  version = "2.24.5";

  src = fetchurl {
    url = "mirror://gnome/sources/gtkmm/${lib.versions.majorMinor version}/gtkmm-${version}.tar.xz";
    sha256 = "0680a53b7bf90b4e4bf444d1d89e6df41c777e0bacc96e9c09fc4dd2f5fe6b72";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = [
    glibmm
    gtk2
    atkmm
    cairomm
    pangomm
  ];

  doCheck = true;

  enableParallelBuilding = true;

  meta = {
    description = "C++ interface to the GTK graphical user interface library";
    homepage = "https://gtkmm.org/";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
}
