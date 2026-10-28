{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kdoctools,
  kcrash,
  kdbusaddons,
  kguiaddons,
  ki18n,
  kparts,
  ktextwidgets,
  kwidgetsaddons,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kmplot";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kmplot-${finalAttrs.version}.tar.xz";
    hash = "sha256-eCC2Dzoxht5iaxwa9sAQJw3QAarNWgaRSUkSDNlhM88=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    kcrash
    kdbusaddons
    kguiaddons
    ki18n
    kparts
    ktextwidgets
    kwidgetsaddons
  ];

  meta = {
    description = "Mathematical Function Plotter";
    homepage = "https://apps.kde.org/kmplot/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kmplot";
  };
})
