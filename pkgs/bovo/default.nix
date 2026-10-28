{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  _7zz,
  kdoctools,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  ki18n,
  kiconthemes,
  kwidgetsaddons,
  kxmlgui,
  libkdegames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bovo";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/bovo-${finalAttrs.version}.tar.xz";
    hash = "sha256-Q3BP9uEZmy/sHGphHLTCc6obrPUWKruJG+gcq95Vo4U=";
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
    kcoreaddons
    kcrash
    kdbusaddons
    ki18n
    kiconthemes
    kwidgetsaddons
    kxmlgui
    libkdegames
  ];

  meta = {
    description = "Bovo is a Gomoku like game for two players";
    homepage = "https://apps.kde.org/bovo/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "bovo";
  };
})
