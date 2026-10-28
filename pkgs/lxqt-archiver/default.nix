{
  qt6,
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  lxqt-build-tools,
  json-glib,
  libexif,
  libfm-qt,
  menu-cache,
  qtbase,
  qttools,
  qtwayland,

}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxqt-archiver";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-archiver";
    tag = finalAttrs.version;
    hash = "sha256-f8s29INIJeqmPr6BWqQxYWWkjbG1wy+bUYZSy2OECKg=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    lxqt-build-tools
    qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    json-glib
    libexif
    libfm-qt
    menu-cache
    qtbase
    qtwayland
  ];

  hardeningDisable = [ "format" ];

  meta = {
    homepage = "https://github.com/lxqt/lxqt-archiver/";
    description = "Archive tool for the LXQt desktop environment";
    mainProgram = "lxqt-archiver";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
