{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:

stdenv.mkDerivation rec {
  pname = "layer-shell-qt";
  version = "6.7.4";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/6.7.4/layer-shell-qt-${version}.tar.xz";
    hash = "sha256-alsGRhlznG9KLecMVqv7rfwzTctiYVKh6BiKgHyoZWc=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    pkg-config
    wayland-scanner
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    extra-cmake-modules
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtwayland
    wayland
    wayland-protocols
  ];

  cmakeFlags = [
    "-DBUILD_TESTING=OFF"
  ];

  meta = {
    description = "Qt6 component to allow creating desktop shell components with layer-shell";
    homepage = "https://invent.kde.org/plasma/layer-shell-qt";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
