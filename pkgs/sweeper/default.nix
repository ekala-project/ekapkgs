{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kbookmarks,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdoctools,
  ki18n,
  ktextwidgets,
  kxmlgui,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sweeper";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/sweeper-${finalAttrs.version}.tar.xz";
    hash = "sha256-+cFezf8UELc/A6XzhEMXLvPXbGhHfJ4eEd9fYfgXq+w=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    kbookmarks
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    ki18n
    ktextwidgets
    kxmlgui
    kdePackages.plasma-activities-stats
  ];

  meta = {
    description = "Application that helps to clean unwanted traces the user leaves on the system";
    homepage = "https://apps.kde.org/sweeper/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    mainProgram = "sweeper";
  };
})
