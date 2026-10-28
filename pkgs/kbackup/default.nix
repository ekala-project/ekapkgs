{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  shared-mime-info,
  libarchive,
  karchive,
  kconfig,
  kcoreaddons,
  kdoctools,
  kguiaddons,
  ki18n,
  kiconthemes,
  kio,
  knotifications,
  kstatusnotifieritem,
  kwidgetsaddons,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kbackup";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kbackup-${finalAttrs.version}.tar.xz";
    hash = "sha256-sHC0VZje/612Lu5gqwd2zRCxHHKRmVo4mWXIq0forc0=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    shared-mime-info
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qt5compat
    libarchive
    karchive
    kconfig
    kcoreaddons
    kguiaddons
    ki18n
    kiconthemes
    kio
    knotifications
    kstatusnotifieritem
    kwidgetsaddons
    kxmlgui
  ];

  meta = {
    description = "Backup program with an easy-to-use interface";
    homepage = "https://apps.kde.org/kbackup/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kbackup";
  };
})
