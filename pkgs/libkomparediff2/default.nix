{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kconfig,
  kcoreaddons,
  ki18n,
  kio,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libkomparediff2";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/libkomparediff2-${finalAttrs.version}.tar.xz";
    hash = "sha256-/9wpOmkEpidANXFoqJt6YclVVXzdu2lZgBWUDRnTaNs=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qt5compat
    kconfig
    kcoreaddons
    ki18n
    kio
    kxmlgui
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Library to compare files and strings, used in Kompare and KDevelop";
    homepage = "https://invent.kde.org/sdk/libkomparediff2";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
