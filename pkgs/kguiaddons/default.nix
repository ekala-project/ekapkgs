{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  pkg-config,
  plasma-wayland-protocols,
  wayland,
  wayland-protocols,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kguiaddons";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kguiaddons-${finalAttrs.version}.tar.xz";
    hash = "sha256-6YhkIo0cXiPzQoAl65koaXN0/cPt3rs6nexXDeAopi0=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
    plasma-wayland-protocols
    wayland
    wayland-protocols
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Addons to QtGui";
    homepage = "https://invent.kde.org/frameworks/kguiaddons";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
