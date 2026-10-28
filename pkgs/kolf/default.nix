{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  _7zz,
  kdoctools,
  kcompletion,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  ki18n,
  kiconthemes,
  kio,
  ktextwidgets,
  kwidgetsaddons,
  kxmlgui,
  libkdegames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kolf";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kolf-${finalAttrs.version}.tar.xz";
    hash = "sha256-ltNMPkgb4yU2U1/gHaPE4UU2oppattPEVSoXxZelHcg=";
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
    kcompletion
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    kdbusaddons
    ki18n
    kiconthemes
    kio
    ktextwidgets
    kwidgetsaddons
    kxmlgui
    libkdegames
  ];

  meta = {
    description = "Kolf is a miniature golf game with 2d top-down view";
    homepage = "https://apps.kde.org/kolf/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kolf";
  };
})
