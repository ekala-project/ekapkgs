{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  lxqt-build-tools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libqtxdg";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "libqtxdg";
    tag = finalAttrs.version;
    hash = "sha256-9Hj5RnPWtqRkzhrAuXoHnMAQloFbnF/8koPT8ExfSAs=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    lxqt-build-tools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
  ];

  cmakeEntries = {
    QTXDGX_ICONENGINEPLUGIN_INSTALL_PATH = "$(out)/${qt6.qtbase.qtPluginPrefix}/iconengines";
    CMAKE_INSTALL_INCLUDEDIR = "include";
    CMAKE_INSTALL_LIBDIR = "lib";
  };

  meta = {
    homepage = "https://github.com/lxqt/libqtxdg";
    description = "Qt implementation of freedesktop.org xdg specs";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
