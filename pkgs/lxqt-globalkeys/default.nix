{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  lxqt-build-tools,
  qt6,
  kwindowsystem,
  liblxqt,
  libqtxdg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxqt-globalkeys";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-globalkeys";
    tag = finalAttrs.version;
    hash = "sha256-VhySpJYHdi17U4yJBWXEWE2KEyG7AVcWYLpYXr2iCyc=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    lxqt-build-tools
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    kwindowsystem
    liblxqt
    libqtxdg
  ];

  meta = {
    homepage = "https://github.com/lxqt/lxqt-globalkeys";
    description = "LXQt service for global keyboard shortcuts registration";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
