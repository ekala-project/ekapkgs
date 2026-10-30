{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libsm,
  libxdmcp,
  libpthread-stubs,
  lxqt-build-tools,
  openbox,
  pkg-config,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obconf-qt";
  version = "0.16.6";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "obconf-qt";
    tag = finalAttrs.version;
    hash = "sha256-Qd8vIfYjY/etv2IXEqQQM1ni0eS6Vuk/MnqtuLh4Mow=";
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
    libsm
    libxdmcp
    libpthread-stubs
    openbox
    qt6.qtbase
    qt6.qtwayland
  ];

  meta = {
    homepage = "https://github.com/lxqt/obconf-qt";
    description = "Qt port of obconf, the Openbox configuration tool";
    mainProgram = "obconf-qt";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
