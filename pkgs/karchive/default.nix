{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  pkg-config,
  xz,
  zlib,
  zstd,
}:

stdenv.mkDerivation rec {
  pname = "karchive";
  version = "6.27.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.27/karchive-${version}.tar.xz";
    hash = "sha256-Q07feN+PTJ8lAA0QetFSDXrBTbWAogIEe/Gcv3c3ZSI=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    pkg-config
    qt6.qttools
  ];

  buildInputs = [
    extra-cmake-modules
    qt6.qtbase
    xz
    zlib
    zstd
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    "-DBUILD_TESTING=OFF"
  ];

  meta = {
    description = "File compression and decompression framework";
    homepage = "https://invent.kde.org/frameworks/karchive";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
}
