{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kwidgetsaddons";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kwidgetsaddons-${finalAttrs.version}.tar.xz";
    hash = "sha256-qxMzwlhnjKp1YhIKHAO7cXefcjLxoOdblSXZId7j4KM=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Addons to QtWidgets";
    homepage = "https://invent.kde.org/frameworks/kwidgetsaddons";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
