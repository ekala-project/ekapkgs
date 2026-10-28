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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxqt-about";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-about";
    tag = finalAttrs.version;
    hash = "sha256-wJ4KJ+gSj0sdlO1l68RzAaOM8HxdPP6S1gWCoRfRZ3c=";
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
    qt6.qtsvg
    qt6.qtwayland
  ];

  meta = {
    homepage = "https://github.com/lxqt/lxqt-about";
    description = "Dialogue window providing information about LXQt and the system it's running on";
    mainProgram = "lxqt-about";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
