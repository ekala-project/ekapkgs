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

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    (lib.cmakeBool "WANT_ALSA" true)
    (lib.cmakeBool "WANT_PULSEAUDIO" true)
    (lib.cmakeBool "WANT_SOUNDIO" false)
    (lib.cmakeBool "WANT_PORTAUDIO" false)
    (lib.cmakeBool "WANT_SNDIO" false)
    (lib.cmakeBool "WANT_JACK" true)
    (lib.cmakeBool "WANT_WEAKJACK" true)
    (lib.cmakeBool "WANT_SDL" true)
    (lib.cmakeBool "WANT_OGGVORBIS" true)
    (lib.cmakeBool "WANT_MP3LAME" true)
    (lib.cmakeBool "WANT_SF2" true)
    (lib.cmakeBool "WANT_GIG" true)
    (lib.cmakeBool "WANT_SID" true)
    (lib.cmakeBool "WANT_SWH" true)
    (lib.cmakeBool "WANT_LV2" true)
    (lib.cmakeBool "WANT_VST" false)
    # TODO(corepkgs): port carla for Carla plugin host support
    (lib.cmakeBool "WANT_CARLA" false)
  ];

  meta = {
    description = "DAW similar to FL Studio (music production software)";
    homepage = "https://lmms.io";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "lmms";
  };
})
