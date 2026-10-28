{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcoreaddons,
  kcrash,
  kdoctools,
  ki18n,
  kio,
  kxmlgui,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "skanlite";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/skanlite-${finalAttrs.version}.tar.xz";
    hash = "sha256-V3iYNam8SI5+iyBOd6Y2z1MWZZIpQn41dlTIXCId9cI=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qt5compat
    kcoreaddons
    kcrash
    ki18n
    kio
    kxmlgui
    kdePackages.libksane
  ];

  meta = {
    description = "Lite image scanning application";
    homepage = "https://apps.kde.org/skanlite/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "skanlite";
  };
})
