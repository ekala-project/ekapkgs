{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcodecs,
  kconfig,
  kcoreaddons,
  kdoctools,
  kiconthemes,
  kjobwidgets,
  kparts,
  ktexteditor,
  kwidgetsaddons,
  libkomparediff2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kompare";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kompare-${finalAttrs.version}.tar.xz";
    hash = "sha256-sb7p31hz74F0bYBpJVwobADK4Xm7irOIcPYWgG9ht3Y=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    kcodecs
    kconfig
    kcoreaddons
    kiconthemes
    kjobwidgets
    kparts
    ktexteditor
    kwidgetsaddons
    libkomparediff2
  ];

  meta = {
    description = "Graphical File Differences Tool";
    homepage = "https://apps.kde.org/kompare/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kompare";
  };
})
