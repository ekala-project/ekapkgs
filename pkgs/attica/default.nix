{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "attica";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/attica-${finalAttrs.version}.tar.xz";
    hash = "sha256-PuyNLZx3rV98/TjkTksUksXQ3saVsT9xHAn31hh8J2w=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Open Collaboration Services API library";
    homepage = "https://invent.kde.org/frameworks/attica";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
