{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  _7zz,
  kdoctools,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  ki18n,
  kiconthemes,
  kio,
  knewstuff,
  ktextwidgets,
  kwidgetsaddons,
  kxmlgui,
  libkdegames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kigo";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kigo-${finalAttrs.version}.tar.xz";
    hash = "sha256-6tQAlhAKEMVktIANhBvqDreRTZBM3olnficmEmYnhMU=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
    _7zz
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    kdbusaddons
    ki18n
    kiconthemes
    kio
    knewstuff
    ktextwidgets
    kwidgetsaddons
    kxmlgui
    libkdegames
  ];

  meta = {
    description = "Kigo is an open-source implementation of the popular Go game";
    homepage = "https://apps.kde.org/kigo/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kigo";
  };
})
