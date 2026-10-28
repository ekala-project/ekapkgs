{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kdoctools,
  kcrash,
  kdbusaddons,
  kguiaddons,
  ki18n,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blinken";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/blinken-${finalAttrs.version}.tar.xz";
    hash = "sha256-SZjk9iWu/uFJjFV4fhjZDgh78rmPjBWRaE7/sZSllvw=";
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
    qt6.qtsvg
    kcrash
    kdbusaddons
    kguiaddons
    ki18n
    kxmlgui
  ];

  meta = {
    description = "Memory Enhancement Game";
    homepage = "https://apps.kde.org/blinken/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "blinken";
  };
})
