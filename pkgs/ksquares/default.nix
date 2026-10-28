{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kdoctools,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  ki18n,
  kwidgetsaddons,
  kxmlgui,
  libkdegames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ksquares";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/ksquares-${finalAttrs.version}.tar.xz";
    hash = "sha256-zJvThPAiW4wvu6IbO50Z2KoDJE28pmuRtmlYZXD9Pl8=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    kdbusaddons
    ki18n
    kwidgetsaddons
    kxmlgui
    libkdegames
  ];

  meta = {
    description = "KSquares is modeled after the well known pen and paper based game of Dots and Boxes";
    homepage = "https://apps.kde.org/ksquares/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "ksquares";
  };
})
