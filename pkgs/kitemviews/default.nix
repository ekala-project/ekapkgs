{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kitemviews";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kitemviews-${finalAttrs.version}.tar.xz";
    hash = "sha256-lFLysMxd0CFLiMTOMyl4Zr6Jr0F3rxT1OQz7YW5JwVM=";
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
    description = "Widget addons for Qt Model/View";
    homepage = "https://invent.kde.org/frameworks/kitemviews";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
