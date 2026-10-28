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
  ki18n,
  kiconthemes,
  knotifications,
  knotifyconfig,
  kwidgetsaddons,
  kxmlgui,
  libkdegames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kdiamond";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kdiamond-${finalAttrs.version}.tar.xz";
    hash = "sha256-xqc+ttEBYjyc19OsDqkVXG4lawxtt95KLICTEK3ScQk=";
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
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    kdbusaddons
    ki18n
    kiconthemes
    knotifications
    knotifyconfig
    kwidgetsaddons
    kxmlgui
    libkdegames
  ];

  meta = {
    description = "KDiamond is a single player puzzle game";
    homepage = "https://apps.kde.org/kdiamond/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kdiamond";
  };
})
