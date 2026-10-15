{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  gperf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kcodecs";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kcodecs-${finalAttrs.version}.tar.xz";
    hash = "sha256-pCx5/zI3tzeJ0cY839hIwNWWcc5ek3I6LvoSjwDLNFA=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.qttools
    gperf
  ];

  buildInputs = [
    qt6.qtbase
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Collection of methods to manipulate strings using various encodings";
    homepage = "https://invent.kde.org/frameworks/kcodecs";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
