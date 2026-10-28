{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  pkg-config,
  networkmanager,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "networkmanager-qt";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/networkmanager-qt-${finalAttrs.version}.tar.xz";
    hash = "sha256-9rpfVNQT6gsmQiB6br0IA+fLg5K5H8+KFnn9DCEGKGU=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
  ];

  propagatedBuildInputs = [
    networkmanager
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Qt wrapper for NetworkManager API";
    homepage = "https://invent.kde.org/frameworks/networkmanager-qt";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
