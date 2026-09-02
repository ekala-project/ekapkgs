{
  lib,
  stdenv,
  fetchFromGitHub,
  nasm,
  alsa-lib,
  curl,
  flac,
  fluidsynth,
  freetype,
  libjpeg,
  libmad,
  libmpeg2,
  libogg,
  libtheora,
  libvorbis,
  libGLU,
  libGL,
  libx11,
  SDL2,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scummvm";
  version = "2026.3.0";

  src = fetchFromGitHub {
    owner = "scummvm";
    repo = "scummvm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wFEYg3hRVNVlxpw3xP8O8s4ILKy487k5hyWENaLiOlw=";
  };

  nativeBuildInputs = [ nasm ];

  buildInputs = [
    alsa-lib
    libGLU
    libGL
    curl
    freetype
    flac
    fluidsynth
    libjpeg
    libmad
    libmpeg2
    libogg
    libtheora
    libvorbis
    SDL2
    libx11
    zlib
  ];

  dontDisableStatic = true;

  enableParallelBuilding = true;

  configurePlatforms = [ "host" ];
  configureFlags = [
    "--enable-release"
  ];

  # They use 'install -s', that calls the native strip instead of the cross
  postConfigure = ''
    sed -i "s/-c -s/-c -s --strip-program=''${STRIP@Q}/" ports.mk
  '';

  env.NIX_CFLAGS_COMPILE = toString [
    "-fpermissive"
    "-Wno-error=format-security"
  ];

  meta = {
    description = "Program to run certain classic graphical point-and-click adventure games (such as Monkey Island)";
    mainProgram = "scummvm";
    homepage = "https://www.scummvm.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
