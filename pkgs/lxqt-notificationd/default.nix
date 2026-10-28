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
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxqt-notificationd";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-notificationd";
    tag = finalAttrs.version;
    hash = "sha256-o+J7xg60T0WsznDOrfg7EjNlT9FQFbniNkvgkF12N0Q=";
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
    layer-shell-qt
    liblxqt
    libqtxdg
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
  ];

  meta = {
    homepage = "https://github.com/lxqt/lxqt-notificationd";
    description = "LXQt notification daemon";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
