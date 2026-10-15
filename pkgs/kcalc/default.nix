{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcolorscheme,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdoctools,
  kguiaddons,
  ki18n,
  kiconthemes,
  knotifications,
  kxmlgui,
  gmp,
  libmpc,
  mpfr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kcalc";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kcalc-${finalAttrs.version}.tar.xz";
    hash = "sha256-3ph+jHu9Jh6FirQACJ0zPmXFVY/K04QhSzCXRG/5Jfo=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qt5compat
    kcolorscheme
    kconfigwidgets
    kcoreaddons
    kcrash
    kguiaddons
    ki18n
    kiconthemes
    knotifications
    kxmlgui
    gmp
    libmpc
    mpfr
  ];

  meta = {
    description = "KDE calculator";
    homepage = "https://apps.kde.org/kcalc/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kcalc";
  };
})
