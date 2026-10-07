{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt5,
  alsa-lib,
  fftw,
  fltk,
  fluidsynth,
  lame,
  libgig,
  libjack2,
  libogg,
  libpulseaudio,
  libsamplerate,
  libsndfile,
  libvorbis,
  lilv,
  lv2,
  sdl2-compat,
  suil,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lmms";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "LMMS";
    repo = "lmms";
    rev = "fc3dfda961a7923326d2b0d5747e5d8fd941af98";
    hash = "sha256-q8w1CgM2QnkCIOUJlv8r+2zMKl+brbNKoAkhDJEhaN0=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    qt5.qttools
    pkg-config
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    fftw.float
    qt5.qtbase
    qt5.qtsvg
    qt5.qtwayland
    qt5.qtx11extras
    libsamplerate
    libsndfile
    alsa-lib
    libpulseaudio
    libjack2
    sdl2-compat
    libogg
    libvorbis
    lame
    fluidsynth
    fltk
    libgig
    lilv
    lv2
    suil
    perl
  ];

  cmakeEntries = {
    CMAKE_POLICY_VERSION_MINIMUM = "3.5";
    WANT_ALSA = true;
    WANT_PULSEAUDIO = true;
    WANT_SOUNDIO = false;
    WANT_PORTAUDIO = false;
    WANT_SNDIO = false;
    WANT_JACK = true;
    WANT_WEAKJACK = true;
    WANT_SDL = true;
    WANT_OGGVORBIS = true;
    WANT_MP3LAME = true;
    WANT_SF2 = true;
    WANT_GIG = true;
    WANT_SID = true;
    WANT_SWH = true;
    WANT_LV2 = true;
    WANT_VST = false;
    WANT_CARLA = false;
  };

  meta = {
    description = "DAW similar to FL Studio (music production software)";
    homepage = "https://lmms.io";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "lmms";
  };
})
