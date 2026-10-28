{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  libdbusmenu-lxqt ? null,
  kguiaddons,
  kwindowsystem,
  layer-shell-qt,
  libxdamage,
  libxdmcp,
  libxtst,
  libdbusmenu,
  liblxqt,
  libpthread-stubs,
  libpulseaudio,
  libqtxdg,
  libstatgrab,
  libsysstat,
  lm_sensors,
  lxqt-build-tools,
  lxqt-globalkeys,
  lxqt-menu-data ? null,
  pcre2,
  qt6,
  solid,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxqt-panel";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-panel";
    tag = finalAttrs.version;
    hash = "sha256-TExmFE02GDRWWHCzJNETSY5GbOXxxX1OFFrEe9krBqM=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    lxqt-build-tools
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    libdbusmenu-lxqt
    kguiaddons
    kwindowsystem
    layer-shell-qt
    libxdamage
    libxdmcp
    libxtst
    libdbusmenu
    liblxqt
    libpthread-stubs
    libpulseaudio
    libqtxdg
    libstatgrab
    libsysstat
    lm_sensors
    lxqt-globalkeys
    lxqt-menu-data
    pcre2
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
    solid
  ];

  meta = {
    homepage = "https://github.com/lxqt/lxqt-panel";
    description = "LXQt desktop panel";
    mainProgram = "lxqt-panel";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
