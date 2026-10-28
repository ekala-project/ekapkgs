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
  knewstuff,
  kwidgetsaddons,
  kxmlgui,
  libkdegames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "katomic";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/katomic-${finalAttrs.version}.tar.xz";
    hash = "sha256-0L5bXz7/cJj4N7kA7h++ppbW1Q30AYgvdthJUE/GJLY=";
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
    knewstuff
    kwidgetsaddons
    kxmlgui
    libkdegames
  ];

  meta = {
    description = "Katomic is a fun and educational game built around molecular geometry";
    homepage = "https://apps.kde.org/katomic/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "katomic";
  };
})
