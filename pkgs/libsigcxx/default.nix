{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "libsigc++";
  version = "2.12.1";

  src = fetchurl {
    url = "mirror://gnome/sources/libsigc++/${lib.versions.majorMinor version}/libsigc++-${version}.tar.xz";
    sha256 = "sha256-qdvuMjNR0Qm3ruB0qcuJyj57z4rY7e8YUfTPNZvVCEM=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
  ];

  mesonBuildType = "release";

  meta = {
    homepage = "https://libsigcplusplus.github.io/libsigcplusplus/";
    description = "Typesafe callback system for standard C++";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.all;
  };
}
