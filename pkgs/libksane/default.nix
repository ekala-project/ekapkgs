{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  ki18n,
  ksanecore,
  ktextwidgets,
  kwallet,
  kwidgetsaddons,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libksane";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/libksane-${finalAttrs.version}.tar.xz";
    hash = "sha256-3ZkLl3o1dfVzBPZBP1ndn2erICgozzED3LUDXv4+cDU=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
    ki18n
    ksanecore
    ktextwidgets
    kwallet
    kwidgetsaddons
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Library providing QWidget with all the logic to interface scanners";
    homepage = "https://invent.kde.org/graphics/libksane";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
