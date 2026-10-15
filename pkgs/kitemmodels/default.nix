{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kitemmodels";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kitemmodels-${finalAttrs.version}.tar.xz";
    hash = "sha256-+Afls3qpE9JWPuGiGyvOfTRJXzLzjH818WJi1za9/VU=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Models for Qt Model/View system";
    homepage = "https://invent.kde.org/frameworks/kitemmodels";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
