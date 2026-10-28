{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  autoPatchelfHook,
  kwindowsystem,
  layer-shell-qt,
  libxdmcp,
  libpthread-stubs,
  libqtxdg,
  lxqt-build-tools,
  perl,
  pkg-config,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "screengrab";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "screengrab";
    tag = finalAttrs.version;
    hash = "sha256-WgQWFNAu+cws442o1HubuaANsg0Hxg0XLyZ/CeA3abM=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    lxqt-build-tools
    pkg-config
    perl # needed by LXQtTranslateDesktop.cmake
    qt6.qttools
    autoPatchelfHook # fix libuploader.so and libextedit.so not found
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    kwindowsystem
    layer-shell-qt
    libxdmcp
    libpthread-stubs
    libqtxdg
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
  ];

  meta = {
    homepage = "https://github.com/lxqt/screengrab";
    description = "Crossplatform tool for fast making screenshots";
    mainProgram = "screengrab";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
