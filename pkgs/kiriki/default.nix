{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kdoctools,
  ki18n,
  kiconthemes,
  kwidgetsaddons,
  kxmlgui,
  libkdegames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kiriki";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kiriki-${finalAttrs.version}.tar.xz";
    hash = "sha256-AAKHF68tvL2m7T2VWKoeAT2BGlyWvMLQpoFGXfFgLBs=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
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
    kwidgetsaddons
    kxmlgui
    libkdegames
  ];

  meta = {
    description = "Kiriki is an addictive and fun dice game";
    homepage = "https://apps.kde.org/kiriki/";
    license = with lib.licenses; [
      bsd3
    ];
    platforms = lib.platforms.linux;
    mainProgram = "kiriki";
  };
})
