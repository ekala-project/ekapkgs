{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcodecs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kmime";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kmime-${finalAttrs.version}.tar.xz";
    hash = "sha256-KWml70hOmPkb946IyYqdYTvdO7hqwVTO7OBVe3Dzc7w=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    kcodecs
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Library to assist handling MIME data";
    homepage = "https://invent.kde.org/frameworks/kmime";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
