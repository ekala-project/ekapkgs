{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libdbusmenu-lxqt ? null,
  libfm-qt,
  libqtxdg,
  lxqt-build-tools,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxqt-qtplugin";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-qtplugin";
    tag = finalAttrs.version;
    hash = "sha256-Ax12jHeNTyEI+2dYj9aW8S6wzDVKN+I9U7ufhx6rycQ=";
  };

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace-fail "DESTINATION \"\''${QT_PLUGINS_DIR}" "DESTINATION \"$qtPluginPrefix"
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    lxqt-build-tools
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    libdbusmenu-lxqt
    libfm-qt
    libqtxdg
    qt6.qtbase
    qt6.qtsvg
  ];

  meta = {
    homepage = "https://github.com/lxqt/lxqt-qtplugin";
    description = "LXQt Qt platform integration plugin";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
