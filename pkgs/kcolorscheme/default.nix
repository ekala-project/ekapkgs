{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kconfig,
  kguiaddons,
  ki18n,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kcolorscheme";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kcolorscheme-${finalAttrs.version}.tar.xz";
    hash = "sha256-pBKOguR81HTHd3VMTdivKKAKV+zziNoaYvgXPYmIkNA=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
    kconfig
    kguiaddons
    ki18n
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Classes to read and interact with KColorScheme";
    homepage = "https://invent.kde.org/frameworks/kcolorscheme";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
