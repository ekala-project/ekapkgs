{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  pkg-config,
  libraw,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libkdcraw";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/libkdcraw-${finalAttrs.version}.tar.xz";
    hash = "sha256-Hk78xBbYwqP1wePB1FiTjKJDl1/NoJS5EBmZF19QWVk=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    libraw
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "C++ interface around LibRaw library";
    homepage = "https://invent.kde.org/graphics/libkdcraw";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
