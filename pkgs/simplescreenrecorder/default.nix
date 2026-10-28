{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  ffmpeg,
  libjack2,
  libx11,
  libxext,
  libxinerama,
  libxfixes,
  libGLU,
  libGL,
  pkg-config,
  libpulseaudio,
  libv4l,
  pipewire,
  libsForQt5,
  cmake,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "simplescreenrecorder";
  version = "0.4.4-unstable-2026-08-15";

  src = fetchFromGitHub {
    owner = "MaartenBaert";
    repo = "ssr";
    rev = "e73e07664121ac30836872bca76194c6570e04c8";
    hash = "sha256-2uO1bVLJ3w9tN69pgFUTh9upY6cf3ABLdkDSgWnOcJs=";
  };

  cmakeEntries = {
    WITH_QT5 = true;
    WITH_GLINJECT = stdenv.hostPlatform.isx86;
  };

  postPatch = ''
    substituteInPlace scripts/ssr-glinject \
      --replace-fail "libssr-glinject.so" "$out/lib/libssr-glinject.so"

    substituteInPlace src/AV/Input/GLInjectInput.cpp \
      --replace-fail "/bin/sh" "${stdenv.shell}" \
      --replace-fail "libssr-glinject.so" "$out/lib/libssr-glinject.so"
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    cmake.configurePhaseHook
    ninja
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    ffmpeg
    libjack2
    libx11
    libxext
    libxfixes
    libxinerama
    libGLU
    libGL
    libpulseaudio
    libv4l
    pipewire
    libsForQt5.qtbase
    libsForQt5.qttools
    libsForQt5.qtx11extras
  ];

  meta = {
    description = "Screen recorder for Linux";
    homepage = "https://www.maartenbaert.be/simplescreenrecorder";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
