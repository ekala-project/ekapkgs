{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libpulseaudio,
  lxqt-build-tools,
  pkg-config,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pavucontrol-qt";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "pavucontrol-qt";
    tag = finalAttrs.version;
    hash = "sha256-Ja+9Tb88SxdvsJPiQadeziCgFtOnInTBSHcisNjrSpA=";
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
    libpulseaudio
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
  ];

  meta = {
    homepage = "https://github.com/lxqt/pavucontrol-qt";
    description = "Pulseaudio mixer in Qt (port of pavucontrol)";
    mainProgram = "pavucontrol-qt";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
