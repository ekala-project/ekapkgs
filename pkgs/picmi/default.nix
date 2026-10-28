{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  _7zz,
  kdoctools,
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
  pname = "picmi";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/picmi-${finalAttrs.version}.tar.xz";
    hash = "sha256-HQZcrK/ZEFriSUHiW+B7vUspQU5aIyHccSkfKV/AMjE=";
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
    qt6.qtsvg
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
    description = "A nonogram logic game by KDE";
    homepage = "https://apps.kde.org/picmi/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "picmi";
  };
})
