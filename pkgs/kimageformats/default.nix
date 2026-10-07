{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  pkg-config,
  qt6,
  karchive,
  libheif,
  libjxl,
  libavif,
  libraw,
  openexr,
}:

stdenv.mkDerivation rec {
  pname = "kimageformats";
  version = "6.27.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.27/kimageformats-${version}.tar.xz";
    hash = "sha256-ap9Ak2upRieQY8va6kc7nrc1tTBHsBJMiKyn2xfMq6w=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    pkg-config
    qt6.wrapQtAppsHook
  ];

  dontWrapQtApps = true;

  buildInputs = [
    extra-cmake-modules
    qt6.qtbase
    karchive
    libheif
    libjxl
    libavif
    libraw
    openexr
  ];

  cmakeEntries = {
    BUILD_TESTING = false;
    KIMAGEFORMATS_HEIF = true;
  };

  meta = {
    description = "Image format plugins for Qt6 providing AVIF, HEIF, JXL and other formats";
    homepage = "https://invent.kde.org/frameworks/kimageformats";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
}
