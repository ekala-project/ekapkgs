{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kdoctools,
  kcoreaddons,
  kcrash,
  ki18n,
  kio,
  knewstuff,
  ktextwidgets,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kturtle";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kturtle-${finalAttrs.version}.tar.xz";
    hash = "sha256-lES11Zr9+yHeAnH+uFh5Smjo1500W9elvbtwodJWaio=";
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
    kcoreaddons
    kcrash
    ki18n
    kio
    knewstuff
    ktextwidgets
    kxmlgui
  ];

  meta = {
    description = "Educational programming environment that uses TurtleSpeak";
    homepage = "https://apps.kde.org/kturtle/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kturtle";
  };
})
