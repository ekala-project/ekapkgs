{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  _7zz,
  kdoctools,
  kconfig,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  ki18n,
  kiconthemes,
  kwidgetsaddons,
  kxmlgui,
  libkdegames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kollision";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kollision-${finalAttrs.version}.tar.xz";
    hash = "sha256-JpaxrD6NQvLUuyKb2aw5jUapfZSMaxiolBpbKHWlNP4=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
    _7zz
  ];

  buildInputs = [
    qt6.qtbase
    kconfig
    kcoreaddons
    kcrash
    kdbusaddons
    ki18n
    kiconthemes
    kwidgetsaddons
    kxmlgui
    libkdegames
  ];

  meta = {
    description = "Kollision is a simple ball dodging game";
    homepage = "https://apps.kde.org/kollision/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kollision";
  };
})
