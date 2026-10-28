{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  pkg-config,
  qt6,
  kcmutils,
  kcoreaddons,
  kdbusaddons,
  ki18n,
  kitemmodels,
  kwidgetsaddons,
  kwindowsystem,
  lcms2,
  libxrandr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "colord-kde";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/colord-kde-${finalAttrs.version}.tar.xz";
    hash = "sha256-s6EvG6uILZqghXiJuTF43SwrRdMfmwaQE7TUGy3D3Nk=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    kcmutils
    kcoreaddons
    kdbusaddons
    ki18n
    kitemmodels
    kwidgetsaddons
    kwindowsystem
    lcms2
    libxrandr
  ];

  meta = {
    description = "Provides interfaces and session daemon to colord";
    homepage = "https://invent.kde.org/graphics/colord-kde";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "colord-kde-icc-importer";
  };
})
