{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  bison,
  flex,
  kholidays,
  ki18n,
  boost,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kopeninghours";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kopeninghours-${finalAttrs.version}.tar.xz";
    hash = "sha256-F/ZxBiX1igabIP9t42Iyq/tMTM3ZDZP3ObX7ahFyaxQ=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    bison
    flex
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    kholidays
    ki18n
    (boost.override {
      enablePython = true;
      python = python3;
    })
    python3
  ];

  meta = {
    description = "Library for parsing and evaluating OSM opening hours expressions";
    homepage = "https://apps.kde.org/kopeninghours/";
    license = with lib.licenses; [
      bsd3
      lgpl2Plus
    ];
    platforms = lib.platforms.linux;
  };
})
