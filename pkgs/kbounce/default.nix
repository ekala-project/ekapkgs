{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  _7zz,
  kdoctools,
  kcolorscheme,
  kcompletion,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  ki18n,
  kiconthemes,
  kio,
  kwidgetsaddons,
  kxmlgui,
  libkdegames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kbounce";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kbounce-${finalAttrs.version}.tar.xz";
    hash = "sha256-CaemqqViRHXacGpN4NUWL5oF3xS5cXMOA/Tm/OiUJN8=";
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
    kcolorscheme
    kcompletion
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    kdbusaddons
    ki18n
    kiconthemes
    kio
    kwidgetsaddons
    kxmlgui
    libkdegames
  ];

  meta = {
    description = "KBounce is a single player arcade game with the elements of puzzle";
    homepage = "https://apps.kde.org/kbounce/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kbounce";
  };
})
