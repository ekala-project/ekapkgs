{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  pkg-config,
  qt6,
  hunspell,
  kddockwidgets,
  kcolorscheme,
  kconfig,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kdoctools,
  ki18n,
  kio,
  knotifications,
  kxmlgui,
  sonnet,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lokalize";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/lokalize-${finalAttrs.version}.tar.xz";
    hash = "sha256-98c8d6FYzy3zOafMBA6a3ZmagzHwwrKm26LivhDq7/0=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    pkg-config
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    hunspell
    kddockwidgets
    kcolorscheme
    kconfig
    kcoreaddons
    kcrash
    kdbusaddons
    ki18n
    kio
    knotifications
    kxmlgui
    sonnet
  ];

  meta = {
    description = "Computer-aided translation";
    homepage = "https://apps.kde.org/lokalize/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
