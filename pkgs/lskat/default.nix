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
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kguiaddons,
  ki18n,
  kiconthemes,
  kwidgetsaddons,
  kxmlgui,
  libkdegames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lskat";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/lskat-${finalAttrs.version}.tar.xz";
    hash = "sha256-FXEB5p1ME1YSlBm0u4ICWNsrd+7tuL62PXn1vTWlpz4=";
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
    kcoreaddons
    kcrash
    kdbusaddons
    kguiaddons
    ki18n
    kiconthemes
    kwidgetsaddons
    kxmlgui
    libkdegames
  ];

  meta = {
    description = "Lieutenant Skat is a fun and engaging card game for two players";
    homepage = "https://apps.kde.org/lskat/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "lskat";
  };
})
