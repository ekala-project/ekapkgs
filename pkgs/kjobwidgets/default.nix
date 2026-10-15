{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcoreaddons,
  knotifications,
  kwidgetsaddons,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kjobwidgets";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kjobwidgets-${finalAttrs.version}.tar.xz";
    hash = "sha256-vzbjYZ3xxq09kAvTZDPZerKVvkHBzEAf8OdmOAeIu64=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    kcoreaddons
    knotifications
    kwidgetsaddons
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Widgets for showing progress of asynchronous jobs";
    homepage = "https://invent.kde.org/frameworks/kjobwidgets";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
