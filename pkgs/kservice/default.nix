{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kconfig,
  kcoreaddons,
  kdoctools,
  ki18n,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kservice";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kservice-${finalAttrs.version}.tar.xz";
    hash = "sha256-5jBiUE7eTr/aTJPjSEpjgXcx4RV83KxuM/tH/mq8Flc=";
  };

  patches = [
    ./handle-sycoca-deletion.patch
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
    kconfig
    kcoreaddons
    kdoctools
    ki18n
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Advanced plugin and service introspection";
    homepage = "https://invent.kde.org/frameworks/kservice";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
