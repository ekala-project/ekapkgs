{
  qt6,
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kwindowsystem,
  liblxqt,
  libqtxdg,
  lxqt-build-tools,
  qtbase,
  qtsvg,
  qttools,
  qtwayland,

}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qps";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "qps";
    tag = finalAttrs.version;
    hash = "sha256-KH92JZkVLxz2iECF5z39yzAwt7TU2/WnJomPoAn8iDI=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    lxqt-build-tools
    qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    kwindowsystem
    liblxqt
    libqtxdg
    qtbase
    qtsvg
    qtwayland
  ];

  meta = {
    homepage = "https://github.com/lxqt/qps";
    description = "Qt based process manager";
    mainProgram = "qps";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
