{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  graphviz,
  karchive,
  kconfig,
  kcoreaddons,
  kdbusaddons,
  kdoctools,
  ki18n,
  kio,
  kwidgetsaddons,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kcachegrind";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kcachegrind-${finalAttrs.version}.tar.xz";
    hash = "sha256-ZBqAn3ulqXY3ggIitsf8Y517xdShA2xpxIhoI+2wZwo=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    qt6.qttools
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    karchive
    kconfig
    kcoreaddons
    kdbusaddons
    ki18n
    kio
    kwidgetsaddons
    kxmlgui
  ];

  qtWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ graphviz ]}"
  ];

  meta = {
    description = "GUI to profilers such as Valgrind";
    homepage = "https://apps.kde.org/kcachegrind/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
