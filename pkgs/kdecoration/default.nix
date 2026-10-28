{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  ki18n,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kdecoration";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/kdecoration-${finalAttrs.version}.tar.xz";
    hash = "sha256-f/H+KFTKCKIaG6R/GwyX0S6iTx22GGMTGcukAjylPYY=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    ki18n
  ];

  meta = {
    description = "Plugin based library to create window decorations";
    homepage = "https://invent.kde.org/plasma/kdecoration";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
