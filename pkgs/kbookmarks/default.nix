{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kconfig,
  kcoreaddons,
  kwidgetsaddons,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kbookmarks";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kbookmarks-${finalAttrs.version}.tar.xz";
    hash = "sha256-aAEg8Jkp1R2gpl6WoffSD/u90nlaFlcZsNB+AEded8Q=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    kconfig
    kcoreaddons
    kwidgetsaddons
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Support for bookmarks and the XBEL format";
    homepage = "https://invent.kde.org/frameworks/kbookmarks";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
