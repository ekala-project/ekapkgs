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
  plasma-wayland-protocols,
  libxscrnsaver,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kidletime";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kidletime-${finalAttrs.version}.tar.xz";
    hash = "sha256-IocyBCkt23V+WgpXAExX3r4Shc0P1OeW0H6d4kAuYMM=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
    wayland
    wayland-protocols
    plasma-wayland-protocols
    libxscrnsaver
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Monitoring user activity";
    homepage = "https://invent.kde.org/frameworks/kidletime";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
