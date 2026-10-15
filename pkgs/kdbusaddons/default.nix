{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kdbusaddons";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kdbusaddons-${finalAttrs.version}.tar.xz";
    hash = "sha256-Bj74BGD3bYbcSwM+8EtltpuoLuDeQQRA/mCUZef1qZc=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Addons to QtDBus";
    homepage = "https://invent.kde.org/frameworks/kdbusaddons";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
