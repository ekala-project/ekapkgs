{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcmutils,
  kconfig,
  kcoreaddons,
  kcrash,
  kdoctools,
  kio,
  kjobwidgets,
  knotifications,
  kstatusnotifieritem,
  kwidgetsaddons,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kdf";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kdf-${finalAttrs.version}.tar.xz";
    hash = "sha256-nB+NbuCfNVBfFWLk5YAwOku/ZQWTadSpos4Q9R70m64=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    kcmutils
    kconfig
    kcoreaddons
    kcrash
    kio
    kjobwidgets
    knotifications
    kstatusnotifieritem
    kwidgetsaddons
    kxmlgui
  ];

  meta = {
    description = "Displays available storage devices and information about their usage";
    homepage = "https://apps.kde.org/kdf/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
