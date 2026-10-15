{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  breeze-icons,
  karchive,
  kcolorscheme,
  kconfig,
  ki18n,
  kwidgetsaddons,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kiconthemes";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kiconthemes-${finalAttrs.version}.tar.xz";
    hash = "sha256-wMaEgj0OCH81FozXnxBT/TWLuPtHsnmWoRx9fuPab00=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    qt6.qttools
    breeze-icons
    karchive
    kcolorscheme
    kconfig
    ki18n
    kwidgetsaddons
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Support for icon themes";
    homepage = "https://invent.kde.org/frameworks/kiconthemes";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
