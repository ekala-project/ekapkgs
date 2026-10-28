{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  _7zz,
  kdoctools,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kdnssd,
  ki18n,
  kiconthemes,
  kwidgetsaddons,
  kxmlgui,
  libkdegames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kfourinline";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kfourinline-${finalAttrs.version}.tar.xz";
    hash = "sha256-Nta2kbfJ1FIApyX6pw8tq+OyrlPymTZ33j/aDkRbHLQ=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
    _7zz
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    kdbusaddons
    kdnssd
    ki18n
    kiconthemes
    kwidgetsaddons
    kxmlgui
    libkdegames
  ];

  meta = {
    description = "KFourInLine is a four-in-a-row game";
    homepage = "https://apps.kde.org/kfourinline/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
