{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kconfig,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kdoctools,
  ki18n,
  knewstuff,
  kxmlgui,
  libkdegames,
  libkmahjongg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kmahjongg";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kmahjongg-${finalAttrs.version}.tar.xz";
    hash = "sha256-0QS8ZRfNRZz2cXheYYz7eMFWVm1DCJAS2Nj1dFnaw6E=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    kconfig
    kcoreaddons
    kcrash
    kdbusaddons
    ki18n
    knewstuff
    kxmlgui
    libkdegames
    libkmahjongg
  ];

  qtWrapperArgs = [ "--prefix XDG_DATA_DIRS : ${libkmahjongg}/share" ];

  meta = {
    description = "KMahjongg is a tile matching game for one or two players";
    homepage = "https://apps.kde.org/kmahjongg/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kmahjongg";
  };
})
