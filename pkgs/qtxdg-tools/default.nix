{
  qt6,
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libqtxdg,
  lxqt-build-tools,
  qtbase,
  qtsvg,

}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qtxdg-tools";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "qtxdg-tools";
    tag = finalAttrs.version;
    hash = "sha256-pVFdodYoLQs8o8rF8etd7BKImgJRoDsckGg9DRrwVIY=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    lxqt-build-tools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    libqtxdg
    qtbase
    qtsvg
  ];

  meta = {
    homepage = "https://github.com/lxqt/qtxdg-tools";
    description = "libqtxdg user tools";
    mainProgram = "qtxdg-mat";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
