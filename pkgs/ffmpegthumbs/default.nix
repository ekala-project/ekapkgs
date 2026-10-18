{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  ffmpeg,
  kconfig,
  kio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ffmpegthumbs";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/26.08.2/src/ffmpegthumbs-${finalAttrs.version}.tar.xz";
    hash = "sha256-azkEEoI0HVg+qpCxiStGrHDHCyTy/dnngsUJO6m6wDw=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    ffmpeg
    kconfig
    kio
  ];

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "FFmpeg-based thumbnail generator for KDE";
    homepage = "https://invent.kde.org/multimedia/ffmpegthumbs";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
