{
  lib,
  stdenv,
  SDL,
  SDL2,
  fetchurl,
  gzip,
  libGL,
  libGLU,
  libvorbis,
  libmad,
  flac,
  libopus,
  opusfile,
  libogg,
  libxmp,
  copyDesktopItems,
  makeDesktopItem,
  pkg-config,
  useSDL2 ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quakespasm";
  version = "0.96.3";

  src = fetchurl {
    url = "mirror://sourceforge/quakespasm/quakespasm-${finalAttrs.version}.tar.gz";
    hash = "sha256-tXjWzkpPf04mokRY8YxLzI04VK5iUuuZgu6B2V5QGA4=";
  };

  sourceRoot = "quakespasm-${finalAttrs.version}/Quake";

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
  ];

  buildInputs = [
    gzip
    libGL
    libGLU
    libvorbis
    libmad
    flac
    libopus
    opusfile
    libogg
    libxmp
    (if useSDL2 then SDL2 else SDL)
  ];

  buildFlags = [
    "DO_USERDIRS=1"
    "USE_CODEC_WAVE=1"
    "USE_CODEC_MP3=1"
    "USE_CODEC_VORBIS=1"
    "USE_CODEC_FLAC=1"
    "USE_CODEC_OPUS=1"
    "USE_CODEC_MIKMOD=0"
    "USE_CODEC_UMX=0"
    "USE_CODEC_XMP=1"
    "MP3LIB=mad"
    "VORBISLIB=vorbis"
  ]
  ++ lib.optionals useSDL2 [
    "SDL_CONFIG=sdl2-config"
    "USE_SDL2=1"
  ];

  preInstall = ''
    mkdir -p "$out/bin"
    substituteInPlace Makefile --replace "/usr/local/games" "$out/bin"
  '';

  enableParallelBuilding = true;

  desktopItems = [
    (makeDesktopItem {
      name = "quakespasm";
      exec = "quake";
      desktopName = "Quakespasm";
      categories = [ "Game" ];
    })
  ];

  meta = {
    description = "Engine for iD software's Quake";
    homepage = "https://quakespasm.sourceforge.net/";
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "quake";
    license = lib.licenses.gpl2Only;
  };
})
