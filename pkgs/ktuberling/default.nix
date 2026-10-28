{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcompletion,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kdoctools,
  ki18n,
  kio,
  kwidgetsaddons,
  kxmlgui,
  libkdegames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ktuberling";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/ktuberling-${finalAttrs.version}.tar.xz";
    hash = "sha256-1bRef4YdnCKyWHdgOsJp5jAjfinwp3J4lK9WpHxBcG4=";
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
    kcompletion
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    kdbusaddons
    ki18n
    kio
    kwidgetsaddons
    kxmlgui
    libkdegames
  ];

  meta = {
    description = "KTuberling is a simple constructor game suitable for children and adults alike";
    homepage = "https://apps.kde.org/ktuberling/";
    license = with lib.licenses; [
      gpl2Plus
    ];
    platforms = lib.platforms.linux;
    mainProgram = "ktuberling";
  };
})
