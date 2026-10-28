{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  _7zz,
  svgcleaner,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  ki18n,
  kwidgetsaddons,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libkmahjongg";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/libkmahjongg-${finalAttrs.version}.tar.xz";
    hash = "sha256-X1tZLlSjogKTB6MIDqmMna1D+e5Fo1ba9klllw6rkfE=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    _7zz
    svgcleaner
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    kconfig
    kconfigwidgets
    kcoreaddons
    ki18n
    kwidgetsaddons
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Common code, backgrounds and tile sets for games using Mahjongg tiles";
    homepage = "https://invent.kde.org/games/libkmahjongg";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
