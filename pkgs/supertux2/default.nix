{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  sdl2-compat,
  SDL2_image,
  openal-soft,
  boost,
  curl,
  glew,
  libGL,
  libogg,
  libpng,
  libvorbis,
  freetype,
  glm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "supertux2";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "SuperTux";
    repo = "supertux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jrKIxSfCZyJkEiS9pI61dHcTg2QQKYaLWBb5mFvcqB8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    sdl2-compat
    SDL2_image
    openal-soft
    boost
    curl
    glew
    libGL
    libogg
    libpng
    libvorbis
    freetype
    glm
  ];

  cmakeEntries = {
    INSTALL_SUBDIR_BIN = "bin";
    CMAKE_INSTALL_LIBDIR = "lib";
    ENABLE_OPENGL = true;
  };

  meta = {
    description = "Classic 2D jump'n run sidescroller game";
    homepage = "https://www.supertux.org/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "supertux2";
  };
})
