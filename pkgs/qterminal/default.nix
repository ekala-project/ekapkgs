{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  layer-shell-qt,
  lxqt-build-tools,
  qt6,
  qtermwidget,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qterminal";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "qterminal";
    tag = finalAttrs.version;
    hash = "sha256-8Bp4ZZ/oi4p6pAo/vRAmeSu0tfWZBvTBZTrm4ppJwFU=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    lxqt-build-tools
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    layer-shell-qt
    qt6.qtbase
    qtermwidget
    qt6.qtwayland
  ];

  # TODO(ekaos): replace with integrationTests
  # passthru.tests.test = nixosTests.terminal-emulators.qterminal;

  meta = {
    homepage = "https://github.com/lxqt/qterminal";
    description = "Lightweight Qt-based terminal emulator";
    mainProgram = "qterminal";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
