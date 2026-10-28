{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  _7zz,
  svgcleaner,
  kdoctools,
  karchive,
  kcolorscheme,
  kcompletion,
  kconfig,
  kconfigwidgets,
  kdnssd,
  kguiaddons,
  ki18n,
  kiconthemes,
  knewstuff,
  kxmlgui,
  openal,
  libsndfile,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libkdegames";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/libkdegames-${finalAttrs.version}.tar.xz";
    hash = "sha256-ZPXBoMeYMwV/8j+iRqk4c61lcwyCXCukYpZ0G8B5064=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
    _7zz
    svgcleaner
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    karchive
    kcolorscheme
    kcompletion
    kconfig
    kconfigwidgets
    kdnssd
    kguiaddons
    ki18n
    kiconthemes
    knewstuff
    kxmlgui
    openal
    libsndfile
  ];

  meta = {
    description = "Common code and data for many KDE games";
    homepage = "https://invent.kde.org/games/libkdegames";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
  };
})
