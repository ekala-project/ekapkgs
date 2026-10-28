{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  alsa-lib,
  libjack2,
  dbus,
  qt6,
  # Enable jack session support
  jackSession ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qjackctl";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "rncbc";
    repo = "qjackctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EZR6E6swVRcD8uKZm8zCtps/P/marCfhdUaaOvArayo=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qttools
    alsa-lib
    libjack2
    dbus
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CONFIG_JACK_VERSION" "1")
    (lib.cmakeFeature "CONFIG_JACK_SESSION" (toString jackSession))
  ];

  meta = {
    description = "Qt application to control the JACK sound server daemon";
    mainProgram = "qjackctl";
    homepage = "https://github.com/rncbc/qjackctl";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
