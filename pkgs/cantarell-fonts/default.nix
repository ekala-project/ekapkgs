{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  gettext,
}:

stdenv.mkDerivation rec {
  pname = "cantarell-fonts";
  version = "0.301";

  src = fetchurl {
    url = "mirror://gnome/sources/cantarell-fonts/${version}/cantarell-fonts-${version}.tar.xz";
    hash = "sha256-PTXbCsA/nmsNWlNXdZG3FCOJhfTPwxoKoX8mzXRnXoM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
  ];

  mesonEntries = {
    buildappstream = false;
    fontsdir = "${placeholder ";
    useprebuilt = true;
  };

  mesonFlags = [
    out"}/share/fonts/cantarell"
  ];

  meta = {
    description = "Default typeface used in the user interface of GNOME since version 3.0";
    homepage = "https://cantarell.gnome.org/";
    platforms = lib.platforms.all;
    license = lib.licenses.ofl;
  };
}
