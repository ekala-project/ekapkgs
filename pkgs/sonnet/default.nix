{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  pkg-config,
  aspell,
  hunspell,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sonnet";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/sonnet-${finalAttrs.version}.tar.xz";
    hash = "sha256-FXTvXBfzjjFd4QS5RYDMwbfsHbJlDLS6zi4UFZv2HhA=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.qttools
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    aspell
    hunspell
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Multi-language spell checker";
    homepage = "https://invent.kde.org/frameworks/sonnet";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    mainProgram = "parsetrigrams6";
  };
})
