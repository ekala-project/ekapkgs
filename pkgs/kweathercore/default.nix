{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kholidays,
  ki18n,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kweathercore";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kweathercore-${finalAttrs.version}.tar.xz";
    hash = "sha256-qKWtirjBDz6DUqqm4L33RqSJt48+vtflPk1C1SCZSWE=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtpositioning
    kholidays
    ki18n
  ];

  meta = {
    description = "Library to facilitate retrieval of weather information including forecasts and alerts";
    homepage = "https://apps.kde.org/kweathercore/";
    license = with lib.licenses; [
      bsd2
      lgpl2Plus
    ];
    platforms = lib.platforms.linux;
  };
})
