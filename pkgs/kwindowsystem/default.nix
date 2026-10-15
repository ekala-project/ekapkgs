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
  pname = "kwindowsystem";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kwindowsystem-${finalAttrs.version}.tar.xz";
    hash = "sha256-Y5pQG4d0RrGZBTmdJ+K+K267C7SBq+MgncTVNaEuEso=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.qttools
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
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
    description = "Access to the windowing system";
    homepage = "https://invent.kde.org/frameworks/kwindowsystem";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
