{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kwindowsystem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kstatusnotifieritem";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kstatusnotifieritem-${finalAttrs.version}.tar.xz";
    hash = "sha256-Nz+yP+alwMXHVcRz588nJ5bqWYkcBRV8On6WB6TEr08=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    kwindowsystem
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Implementation of Status Notifier Items";
    homepage = "https://invent.kde.org/frameworks/kstatusnotifieritem";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
