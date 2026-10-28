{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kdoctools,
  kcompletion,
  kconfig,
  kconfigwidgets,
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
  pname = "ksnakeduel";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/ksnakeduel-${finalAttrs.version}.tar.xz";
    hash = "sha256-ZWuHlreY9z136ECX/aqPFXLzbI4u9X0LTXQ+ss8Ogu4=";
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
    kcompletion
    kconfig
    kconfigwidgets
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
    description = "KSnakeDuel is a simple snake duel game";
    homepage = "https://apps.kde.org/ksnakeduel/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "ksnakeduel";
  };
})
