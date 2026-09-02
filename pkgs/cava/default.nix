{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  autoconf-archive,
  alsa-lib,
  fftw,
  iniparser,
  libGL ? null,
  libpulseaudio,
  libtool,
  ncurses,
  pipewire ? null,
  pkg-config,
  portaudio ? null,
  SDL2 ? null,
  withSDL2 ? false,
  withPipewire ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cava";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "karlstav";
    repo = "cava";
    tag = finalAttrs.version;
    hash = "sha256-0vQWobnt9pAZTJc45Lgcfad72BE8DUPGQ5/YwMSmU98=";
  };

  buildInputs = [
    fftw
    iniparser
    libpulseaudio
    libtool
    ncurses
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ]
  ++ lib.optionals withSDL2 [
    libGL
    SDL2
  ]
  ++ lib.optionals withPipewire [
    pipewire
  ];

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
  ];

  preAutoreconf = ''
    echo ${finalAttrs.version} > version
  '';

  meta = {
    description = "Console-based Audio Visualizer for Alsa";
    homepage = "https://github.com/karlstav/cava";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "cava";
  };
})
