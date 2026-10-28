{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  karchive,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdoctools,
  ki18n,
  kiconthemes,
  kparts,
  ktexteditor,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kig";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kig-${finalAttrs.version}.tar.xz";
    hash = "sha256-a945lCNITHTO7iqsIoQbp2G4LX44i8Cm62lxC9jvyqI=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    karchive
    kconfigwidgets
    kcoreaddons
    kcrash
    ki18n
    kiconthemes
    kparts
    ktexteditor
    kxmlgui
  ];

  meta = {
    description = "Interactive Geometry";
    homepage = "https://apps.kde.org/kig/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kig";
  };
})
