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
  pname = "syndication";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/syndication-${finalAttrs.version}.tar.xz";
    hash = "sha256-LUTkWwV2bTQtP+GektKwOckWp6g/nk3/D5+hWGDhQO4=";
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
    kcodecs
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "RSS/Atom parser library";
    homepage = "https://invent.kde.org/frameworks/syndication";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
