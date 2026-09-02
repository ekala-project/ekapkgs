{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rtmidi";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "thestk";
    repo = "rtmidi";
    tag = finalAttrs.version;
    hash = "sha256-QuUeFx8rPpe0+exB3chT6dUceDa/7ygVy+cQYykq7e0=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    alsa-lib
  ];

  cmakeFlags = [
    "-DRTMIDI_API_ALSA=ON"
    "-DRTMIDI_API_JACK=OFF"
  ];

  meta = {
    description = "Set of C++ classes that provide a cross platform API for realtime MIDI input/output";
    homepage = "https://www.music.mcgill.ca/~gary/rtmidi/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
