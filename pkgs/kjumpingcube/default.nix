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
  kio,
  kjobwidgets,
  kwidgetsaddons,
  kxmlgui,
  libkdegames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kjumpingcube";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kjumpingcube-${finalAttrs.version}.tar.xz";
    hash = "sha256-ZHDMSegNTzQ7JeQB1Ur4TeABOFJWWfzWv2t10QXcjXY=";
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
    ki18n
    kiconthemes
    kio
    kjobwidgets
    kwidgetsaddons
    kxmlgui
    libkdegames
  ];

  meta = {
    description = "KJumpingCube is a simple tactical game";
    homepage = "https://apps.kde.org/kjumpingcube/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kjumpingcube";
  };
})
