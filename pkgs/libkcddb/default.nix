{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcmutils,
  kconfig,
  kconfigwidgets,
  kdoctools,
  ki18n,
  kio,
  kwidgetsaddons,
  libmusicbrainz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libkcddb";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/libkcddb-${finalAttrs.version}.tar.xz";
    hash = "sha256-zxWUrcokRK74+t/BwZu56APK5fQ95EpGhx/Gz0gSHiE=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    kcmutils
    kconfig
    kconfigwidgets
    ki18n
    kio
    kwidgetsaddons
    libmusicbrainz
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Library used to retrieve audio CD metadata from the Internet";
    homepage = "https://invent.kde.org/multimedia/libkcddb";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
