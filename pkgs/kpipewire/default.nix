{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  pkg-config,
  qt6,
  kcoreaddons,
  ki18n,
  plasma-wayland-protocols,
  wayland,
  pipewire,
  ffmpeg,
  libgbm,
  libva,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kpipewire";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/6.7.5/kpipewire-${finalAttrs.version}.tar.xz";
    hash = "sha256-IK852UUNSVRoxWpQkwgQ2CE398zTpxBZLgK29iB1j1U=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtquick3d
    kcoreaddons
    ki18n
    plasma-wayland-protocols
    wayland
    pipewire
    ffmpeg
    libgbm
    libva
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "KDE PipeWire integration components";
    homepage = "https://invent.kde.org/plasma/kpipewire";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
