{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  ffmpeg,
  freetype,
  libGLU,
  libjack2,
  liblo,
  libX11,
  libXv,
  pkg-config,
  portmidi,
  libxpm,
  libxext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xjadeo";
  version = "0.8.15";

  src = fetchFromGitHub {
    owner = "x42";
    repo = "xjadeo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/8CxOPDbtr82XuJwBH+Yta6SJB7bsujOPBGwbxrmjZc=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    ffmpeg
    libjack2
    libX11
    libxext
    libxpm
    libXv
    freetype
    libGLU
    liblo
    portmidi
  ];

  meta = {
    description = "X Jack Video Monitor";
    homepage = "https://xjadeo.sourceforge.net";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "xjadeo";
  };
})
