{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  karchive,
  kconfig,
  kcoreaddons,
  kcrash,
  kdoctools,
  ki18n,
  kitemviews,
  ktexteditor,
  ktexttemplate,
  kxmlgui,
  boost,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocs";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/rocs-${finalAttrs.version}.tar.xz";
    hash = "sha256-Dx+eZBuH0Mhy1uFidvR+qfRra3ZEqIhIJR8mA7bv04Y=";
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
    karchive
    kconfig
    kcoreaddons
    kcrash
    ki18n
    kitemviews
    ktexteditor
    ktexttemplate
    kxmlgui
    boost
  ];

  meta = {
    description = "An educational Graph Theory IDE";
    homepage = "https://apps.kde.org/rocs/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "rocs";
  };
})
