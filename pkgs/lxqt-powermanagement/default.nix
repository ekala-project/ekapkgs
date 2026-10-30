{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kidletime,
  kwindowsystem,
  liblxqt,
  libqtxdg,
  lxqt-build-tools,
  lxqt-globalkeys,
  qt6,
  solid,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxqt-powermanagement";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-powermanagement";
    tag = finalAttrs.version;
    hash = "sha256-pHQp/bXeI+yGQJ2rgsP8H7ISpCqcGG+/F74Otz+vJpg=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    lxqt-build-tools
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    kidletime
    kwindowsystem
    liblxqt
    libqtxdg
    lxqt-globalkeys
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
    solid
  ];

  meta = {
    homepage = "https://github.com/lxqt/lxqt-powermanagement";
    description = "Power management module for LXQt";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
