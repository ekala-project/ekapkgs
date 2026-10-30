{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libxdmcp,
  libexif,
  libfm-qt,
  libpthread-stubs,
  lxqt-build-tools,
  menu-cache,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lximage-qt";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lximage-qt";
    tag = finalAttrs.version;
    hash = "sha256-ThP7MuAKysJ/Q/JSO12CuwCt6mCU5tZ2DiKEO0Nfg3U=";
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
    libxdmcp
    libexif
    libfm-qt
    libpthread-stubs
    menu-cache
    qt6.qtbase
    qt6.qtimageformats # add-on module to support more image file formats
    qt6.qtsvg
    qt6.qtwayland
  ];

  meta = {
    homepage = "https://github.com/lxqt/lximage-qt";
    description = "Image viewer and screenshot tool for lxqt";
    mainProgram = "lximage-qt";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
