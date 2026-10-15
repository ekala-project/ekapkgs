{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcoreaddons,
  ki18n,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kpty";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kpty-${finalAttrs.version}.tar.xz";
    hash = "sha256-rWYUnCBHDeKdSD8MzcsFfULM93jz+MyOaK78pTgLrOc=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
  ];

  propagatedBuildInputs = [
    kcoreaddons
    ki18n
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Pty abstraction";
    homepage = "https://invent.kde.org/frameworks/kpty";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
