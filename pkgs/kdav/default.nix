{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kdav";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kdav-${finalAttrs.version}.tar.xz";
    hash = "sha256-CNlc9UbJQdviGnb7yLiKRm8narKehmYAmU9PYNYEx/Q=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
    kio
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "DAV protocol implementation with KJobs";
    homepage = "https://invent.kde.org/frameworks/kdav";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
