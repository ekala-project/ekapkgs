{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kwindowsystem,
  layer-shell-qt,
  libxdmcp,
  liblxqt,
  libpthread-stubs,
  libqtxdg,
  lxqt-build-tools,
  pkg-config,
  procps,
  qt6,
  qtxdg-tools,
  xdg-user-dirs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxqt-session";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-session";
    tag = finalAttrs.version;
    hash = "sha256-CV0g553V4qxq9Cj/RUbr5jxESrrzFjAwR80NKhwNgDU=";
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
    libxdmcp
    liblxqt
    libpthread-stubs
    libqtxdg
    procps
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
    qtxdg-tools
    xdg-user-dirs
  ];

  meta = {
    homepage = "https://github.com/lxqt/lxqt-session";
    description = "Alternative session manager ported from the original razor-session";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
