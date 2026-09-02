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

let
  signalsmith-linear = fetchFromGitHub {
    owner = "Signalsmith-Audio";
    repo = "linear";
    tag = "0.3.1";
    hash = "sha256-m8zQJeZCQcHIwcGq17F2bmuZc4g7mFsxzRCUEpUrkr4=";
  };
  signalsmith-dsp = fetchFromGitHub {
    owner = "Signalsmith-Audio";
    repo = "dsp";
    tag = "v1.7.1";
    hash = "sha256-6TCk3PDJApVnzv6YYDMlqEt5ydmEvYJWmcE8LrD0XEg=";
  };
  signalsmith-hilbert = fetchFromGitHub {
    owner = "Signalsmith-Audio";
    repo = "hilbert-iir";
    tag = "1.0.0";
    hash = "sha256-QSwj1hNdR60GK446jdlH7PPc5HEjmXihZdUfW/ZSC04=";
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "fluidsynth";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "FluidSynth";
    repo = "fluidsynth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eL+QLtdV5veGTkiWvsrxMLIu8cuHvVCJMLLD8fosuDY=";
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
    "-DFETCHCONTENT_SOURCE_DIR_SIGNALSMITH-LINEAR=${signalsmith-linear}"
    "-DFETCHCONTENT_SOURCE_DIR_SIGNALSMITH-DSP=${signalsmith-dsp}"
    "-DFETCHCONTENT_SOURCE_DIR_SIGNALSMITH-HILBERT=${signalsmith-hilbert}"
  ];

  meta = {
    description = "Real-time software synthesizer based on the SoundFont 2 specifications";
    homepage = "https://www.fluidsynth.org";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    mainProgram = "fluidsynth";
  };
})
