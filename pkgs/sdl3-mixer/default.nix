{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  validatePkgConfig,
  sdl3,
  flac,
  fluidsynth,
  game-music-emu,
  libogg,
  libsndfile,
  libvorbis,
  libxmp,
  mpg123,
  opusfile,
  timidity,
  wavpack,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdl3-mixer";
  version = "3.2.4";
  __structuredAttrs = true;

  outputs = [
    "dev"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_mixer";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-mPk6xU1/GkBtWgF8S9ttha7/PNxcBEiSxpzo6ARLC9I=";
  };

  strictDeps = true;
  doCheck = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    pkg-config
    validatePkgConfig
  ];

  buildInputs = [
    sdl3
    flac
    fluidsynth
    game-music-emu
    libogg
    libsndfile
    libvorbis
    libxmp
    mpg123
    opusfile
    timidity
    wavpack
  ];

  # Prefer the packaged timidity config instead of relying on host /etc paths.
  postPatch = ''
    substituteInPlace src/decoder_timidity.c \
      --replace-fail '"/etc/timidity.cfg"' '"${timidity}/share/timidity/timidity.cfg"'
  '';

  cmakeEntries = {
    SDLMIXER_STRICT = true;
    SDLMIXER_DEPS_SHARED = false;
    SDLMIXER_EXAMPLES = false;
    SDLMIXER_FLAC_DRFLAC = false;
    SDLMIXER_MP3_DRMP3 = false;
    SDLMIXER_VORBIS_STB = false;
  };

  cmakeFlags = [
    (lib.cmakeBool "SDLMIXER_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  meta = {
    description = "SDL audio mixer library for SDL3";
    homepage = "https://github.com/libsdl-org/SDL_mixer";
    changelog = "https://github.com/libsdl-org/SDL_mixer/releases/tag/release-${finalAttrs.version}";
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
  };
})
