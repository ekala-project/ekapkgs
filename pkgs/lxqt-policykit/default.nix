{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kwindowsystem,
  liblxqt,
  libqtxdg,
  lxqt-build-tools,
  pkg-config,
  polkit,
  polkit-qt-1,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxqt-policykit";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-policykit";
    tag = finalAttrs.version;
    hash = "sha256-cMYBR0Uwc6v+s+F+uYbClbGh8BgovtxShgB62LX/WgU=";
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
    kwindowsystem
    liblxqt
    libqtxdg
    polkit
    polkit-qt-1
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
  ];

  meta = {
    homepage = "https://github.com/lxqt/lxqt-policykit";
    description = "LXQt PolicyKit agent";
    mainProgram = "lxqt-policykit-agent";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
