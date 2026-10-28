{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kwindowsystem,
  layer-shell-qt,
  liblxqt,
  libqtxdg,
  lxqt-build-tools,
  lxqt-globalkeys,
  muparser,
  pcre2,
  pkg-config,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxqt-runner";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-runner";
    tag = finalAttrs.version;
    hash = "sha256-L/9STKrYTZP/Ey1BCLaZFRdeipBAWdKkXIoiHvd3vq4=";
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
    layer-shell-qt
    liblxqt
    libqtxdg
    lxqt-globalkeys
    muparser
    pcre2
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
  ];

  meta = {
    homepage = "https://github.com/lxqt/lxqt-runner";
    description = "Tool used to launch programs quickly by typing their names";
    mainProgram = "lxqt-runner";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
