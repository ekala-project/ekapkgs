{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcoreaddons,
  ki18n,
  kio,
  kirigami,
  kitemviews,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kcmutils";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kcmutils-6.30.0.tar.xz";
    hash = "sha256-AVn4DQMKwlCws1MROlXAE+1+OMsLZ430TS8NCyrKlEw=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
  ];

  propagatedBuildInputs = [
    kcoreaddons
    ki18n
    kio
    kirigami
    kitemviews
    kxmlgui
  ];

  dontWrapQtApps = true;

  meta = {
    description = "KDE utilities for KDE System Settings modules";
    homepage = "https://invent.kde.org/frameworks/kcmutils";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
