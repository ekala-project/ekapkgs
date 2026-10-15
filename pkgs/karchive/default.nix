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

stdenv.mkDerivation (finalAttrs: {
  pname = "karchive";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/karchive-${finalAttrs.version}.tar.xz";
    hash = "sha256-TPidkeQp0uzjEQ549+9wEZUrBBLLFQETKVFrRvIemOI=";
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

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "File compression and decompression framework";
    homepage = "https://invent.kde.org/frameworks/karchive";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
