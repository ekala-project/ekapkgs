{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  cmake,
  alsa-lib,
  glib,
  libsndfile,
  pulseaudio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fluidsynth";
  version = "2.5.3";

  src = fetchFromGitHub {
    owner = "FluidSynth";
    repo = "fluidsynth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k8IHS6Mh1b1iMSuBg3svlf7A2dsg6VHEKqlDhvyJnbo=";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    glib
    libsndfile
    alsa-lib
    pulseaudio
  ];

  cmakeFlags = [
    "-Denable-framework=off"
    "-Dosal=cpp11"
    "-Denable-libinstpatch=0"
    "-Denable-jack=0"
  ];

  meta = {
    description = "Real-time software synthesizer based on the SoundFont 2 specifications";
    homepage = "https://www.fluidsynth.org";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    mainProgram = "fluidsynth";
    maintainers = [ ];
  };
})
