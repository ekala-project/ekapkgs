{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  alsa-lib,
  libvorbis,
  opusfile,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "miniaudio";
  version = "0.11.25";

  src = fetchFromGitHub {
    owner = "mackron";
    repo = "miniaudio";
    tag = finalAttrs.version;
    hash = "sha256-2k346Z/ueINPbaY20P2cbBvRfFXXH0ugdv4d7WaYt2w=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
  ];

  buildInputs = [
    libvorbis
    opusfile
    alsa-lib
  ];

  cmakeEntries = {
    MINIAUDIO_NO_RUNTIME_LINKING = true;
    MINIAUDIO_BUILD_TESTS = false;
    MINIAUDIO_BUILD_EXAMPLES = false;
    MINIAUDIO_ENABLE_ONLY_SPECIFIC_BACKENDS = true;
    MINIAUDIO_ENABLE_PULSEAUDIO = false;
    MINIAUDIO_ENABLE_JACK = false;
    MINIAUDIO_ENABLE_SNDIO = false;
    MINIAUDIO_ENABLE_ALSA = true;
  };

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  meta = {
    description = "Single header audio playback and capture library written in C";
    homepage = "https://github.com/mackron/miniaudio";
    license = with lib.licenses; [
      unlicense
      mit0
    ];
    platforms = lib.platforms.linux;
  };
})
