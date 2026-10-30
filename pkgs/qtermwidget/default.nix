{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  lxqt-build-tools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qtermwidget";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "qtermwidget";
    tag = finalAttrs.version;
    hash = "sha256-fTE39goab0md0koS28gRiQgnEumtR5/vTKgpM/wuCrk=";
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
  ];

  meta = {
    homepage = "https://github.com/lxqt/qtermwidget";
    description = "Terminal emulator widget for Qt, used by QTerminal";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
