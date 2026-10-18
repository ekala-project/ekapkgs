{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  bison,
  flex,
  libimobiledevice,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "solid";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/solid-${finalAttrs.version}.tar.xz";
    hash = "sha256-vb/cnya4fhK5UQl4Ja8pVvLe4/FMcB14Ane2lwHyx04=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.qttools
    bison
    flex
  ];

  buildInputs = [
    qt6.qtbase
    libimobiledevice
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Hardware integration and detection";
    homepage = "https://invent.kde.org/frameworks/solid";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
