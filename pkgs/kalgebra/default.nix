{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  analitza,
  kconfigwidgets,
  kcoreaddons,
  kdoctools,
  ki18n,
  kio,
  kwidgetsaddons,
  kxmlgui,
  ncurses,
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kalgebra";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kalgebra-${finalAttrs.version}.tar.xz";
    hash = "sha256-vmyFUiApHTuFC/AwLxkoMIE1hxiJZ5T7HeGM1Wu2a10=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwebengine
    analitza
    kconfigwidgets
    kcoreaddons
    ki18n
    kio
    kwidgetsaddons
    kxmlgui
    ncurses
    readline
  ];

  meta = {
    description = "2D and 3D Graph Calculator";
    homepage = "https://apps.kde.org/kalgebra/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kalgebra";
  };
})
