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
  pname = "kreversi";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kreversi-${finalAttrs.version}.tar.xz";
    hash = "sha256-3GL1Ah/5343s5maJEBrz0amxTfoEV28hvFAhdv//RbE=";
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
    description = "KReversi is a simple one player strategy game played against the computer";
    homepage = "https://apps.kde.org/kreversi/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kreversi";
  };
})
