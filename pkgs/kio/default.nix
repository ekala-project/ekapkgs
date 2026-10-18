{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  karchive,
  kbookmarks,
  kcolorscheme,
  kcompletion,
  kconfig,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kdoctools,
  kguiaddons,
  ki18n,
  kiconthemes,
  kitemviews,
  kjobwidgets,
  knotifications,
  kservice,
  kwallet,
  kwidgetsaddons,
  kwindowsystem,
  solid,
  acl,
  attr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kio";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kio-${finalAttrs.version}.tar.xz";
    hash = "sha256-wZy9SHg0e2ep4F7mVBCD9R3ZD55Y7iRbTXY04J+cBLI=";
  };

  patches = [
    ./allow-admin-from-store.patch
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qt5compat
    qt6.qttools
    karchive
    kbookmarks
    kcolorscheme
    kcompletion
    kconfig
    kcoreaddons
    kcrash
    kdbusaddons
    kdoctools
    kguiaddons
    ki18n
    kiconthemes
    kitemviews
    kjobwidgets
    knotifications
    kservice
    kwallet
    kwidgetsaddons
    kwindowsystem
    solid
    acl
    attr
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Resource and network access abstraction";
    homepage = "https://invent.kde.org/frameworks/kio";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
