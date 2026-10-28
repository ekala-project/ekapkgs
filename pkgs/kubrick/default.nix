{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  _7zz,
  kdoctools,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  ki18n,
  kwidgetsaddons,
  kxmlgui,
  libkdegames,
  libGLU,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kubrick";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kubrick-${finalAttrs.version}.tar.xz";
    hash = "sha256-OGzLXMP4seZySCRDGJN3/x+HKVWKIvhG5jiCY3ZYTmI=";
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
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    kdbusaddons
    ki18n
    kwidgetsaddons
    kxmlgui
    libkdegames
    libGLU
  ];

  meta = {
    description = "Kubrick is based on the famous Rubik's Cube";
    homepage = "https://apps.kde.org/kubrick/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kubrick";
  };
})
