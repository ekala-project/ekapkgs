{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  xorg,
  kconfig,
  kdbusaddons,
  kdoctools,
  ki18n,
  kiconthemes,
  kstatusnotifieritem,
  kwidgetsaddons,
  kwindowsystem,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kmousetool";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kmousetool-${finalAttrs.version}.tar.xz";
    hash = "sha256-Xql+wEYwJa3MU4zfFD8wUvG/X/Dk6N6XJAV4h/GmDGA=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtmultimedia
    xorg.libXt
    kconfig
    kdbusaddons
    ki18n
    kiconthemes
    kstatusnotifieritem
    kwidgetsaddons
    kwindowsystem
    kxmlgui
  ];

  meta = {
    description = "Program that clicks the mouse for you";
    homepage = "https://apps.kde.org/kmousetool/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kmousetool";
  };
})
