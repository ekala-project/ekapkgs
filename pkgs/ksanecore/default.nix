{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  ki18n,
  sane-backends,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ksanecore";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/ksanecore-${finalAttrs.version}.tar.xz";
    hash = "sha256-Uytp7xftKceHsNpAUBF/s/q2SZJC0j+SB+XViUyqq5o=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
    ki18n
    sane-backends
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Library providing logic to interface scanners";
    homepage = "https://invent.kde.org/libraries/ksanecore";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
