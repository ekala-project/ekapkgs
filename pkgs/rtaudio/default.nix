{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  pulseaudio,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rtaudio";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "thestk";
    repo = "rtaudio";
    tag = finalAttrs.version;
    hash = "sha256-Acsxbnl+V+Y4mKC1gD11n0m03E96HMK+oEY/YV7rlIY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    validatePkgConfig
  ];

  buildInputs = [
    alsa-lib
    pulseaudio
  ];

  cmakeFlags = [
    (lib.cmakeBool "RTAUDIO_API_ALSA" true)
    (lib.cmakeBool "RTAUDIO_API_PULSE" true)
    (lib.cmakeBool "RTAUDIO_API_JACK" false)
  ];

  meta = {
    description = "Set of C++ classes that provide a cross platform API for realtime audio input/output";
    homepage = "https://www.music.mcgill.ca/~gary/rtaudio/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
