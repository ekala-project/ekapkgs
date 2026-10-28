{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  pkg-config,
  exiv2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libkexiv2";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/libkexiv2-${finalAttrs.version}.tar.xz";
    hash = "sha256-oEkjNzdK4Z2fpzpgVFG6EFNs+/UxCK9+m/d97757zQA=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qt5compat
    exiv2
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Wrapper around Exiv2 library to manipulate picture metadata";
    homepage = "https://invent.kde.org/graphics/libkexiv2";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
