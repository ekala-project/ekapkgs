{
  lib,
  stdenv,
  fetchurl,
  atk,
  glibmm,
  pkg-config,
  meson,
  ninja,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "atkmm";
  version = "2.28.4";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-ChQqgSj4PAAe+4AU7kY+mnZgVO+EaGr5UxNeBNKP2rM=";
  };

  outputs = [
    "out"
    "dev"
  ];

  propagatedBuildInputs = [
    atk
    glibmm
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
    python3
  ];

  doCheck = true;

  meta = {
    description = "C++ wrappers for ATK accessibility toolkit";
    homepage = "https://gtkmm.org";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
}
