{
  cmake,
  fetchFromGitLab,
  lib,
  qt6,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qt6ct";
  version = "0.11";

  src = fetchFromGitLab {
    domain = "www.opencode.net";
    owner = "trialuser";
    repo = "qt6ct";
    tag = finalAttrs.version;
    hash = "sha256-aQmqLpM0vogMsYaDS9OeKVI3N53uY4NBC4FF10hK8Uw=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
  ];

  cmakeFlags = [
    (lib.cmakeFeature "PLUGINDIR" "${placeholder "out"}/${qt6.qtbase.qtPluginPrefix}")
  ];

  meta = {
    description = "Qt6 Configuration Tool";
    homepage = "https://www.opencode.net/trialuser/qt6ct";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd2;
    mainProgram = "qt6ct";
  };
})
