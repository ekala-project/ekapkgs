{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  avahi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kdnssd";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kdnssd-${finalAttrs.version}.tar.xz";
    hash = "sha256-bVmpj1jGaELSn9egDgfg9043UGGqvftMUrvjFAwngiU=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    avahi
  ];

  meta = {
    description = "KDNSSD Framework";
    homepage = "https://invent.kde.org/frameworks/kdnssd";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
