{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kwindowsystem,
  liblxqt,
  libqtxdg,
  lxqt-build-tools,
  qt6,
  sudo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxqt-sudo";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-sudo";
    tag = finalAttrs.version;
    hash = "sha256-wPkIvm6U/dZvf3sE/IsWfK1D647DmVZPV/JZbsRl/HI=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    lxqt-build-tools
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    kwindowsystem
    liblxqt
    libqtxdg
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
    sudo
  ];

  meta = {
    homepage = "https://github.com/lxqt/lxqt-sudo";
    description = "GUI frontend for sudo/su";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
