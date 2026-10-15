{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcodecs,
  kcolorscheme,
  kconfig,
  kcoreaddons,
  kguiaddons,
  ki18n,
  kwidgetsaddons,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kconfigwidgets";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kconfigwidgets-${finalAttrs.version}.tar.xz";
    hash = "sha256-bv2fx3hqfpebMpBK6t8dLY5ppdoRD469RflewC3kH3c=";
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

  propagatedBuildInputs = [
    kcodecs
    kcolorscheme
    kconfig
    kcoreaddons
    kguiaddons
    ki18n
    kwidgetsaddons
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Widgets for KDE configuration dialogs";
    homepage = "https://invent.kde.org/frameworks/kconfigwidgets";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
