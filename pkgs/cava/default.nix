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
  withPipewire ? stdenv.hostPlatform.isLinux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cava";
  version = "0.10.7";

  src = fetchFromGitHub {
    owner = "karlstav";
    repo = "cava";
    tag = finalAttrs.version;
    hash = "sha256-eOGUDGGlja5Cq8XTJFRqyP6qyaoxOJm09vZrlk4KS9k=";
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
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "cava";
  };
})
