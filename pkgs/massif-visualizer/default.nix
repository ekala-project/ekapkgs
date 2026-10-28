{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  shared-mime-info,
  karchive,
  kconfig,
  kcoreaddons,
  ki18n,
  kio,
  kparts,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "massif-visualizer";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/massif-visualizer-${finalAttrs.version}.tar.xz";
    hash = "sha256-wFwPq2OdckQ+b4n53dUrVcMroOgwkQ0WLRyVwLbyC4Y=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    shared-mime-info
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qt5compat
    qt6.qtsvg
    karchive
    kconfig
    kcoreaddons
    ki18n
    kio
    kparts
    kdePackages.kdiagram
    kdePackages.kgraphviewer
  ];

  meta = {
    description = "Visualizer for Valgrind Massif data files";
    homepage = "https://apps.kde.org/massif-visualizer/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "massif-visualizer";
  };
})
