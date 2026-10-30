{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  sdl2-compat,
  openal,
  freetype,
  luajit,
  libmodplug,
  libGL,
  mpg123,
  libvorbis,
  libtheora,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "love";
  version = "11.5";

  src = fetchFromGitHub {
    owner = "love2d";
    repo = "love";
    tag = "${finalAttrs.version}";
    hash = "sha256-wZktNh4UB3QH2wAIIlnYUlNoXbjEDwUmPnT4vesZNm0=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    sdl2-compat
    openal
    freetype
    luajit
    libGL
    libmodplug
    mpg123
    libvorbis
    libtheora
    xorg.libX11
  ];

  meta = {
    description = "LOVE - Free 2D Game Engine";
    homepage = "https://love2d.org/";
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    mainProgram = "love";
  };
})
