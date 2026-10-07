{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  makeWrapper,
  libGL,
  libGLU,
  sdl2-compat,
  SDL2_image,
  fmt,
  gtest ? null,
  libpng,
  libsigcxx ? null,
  argpp ? null,
  geomcpp ? null,
  logmich ? null,
  priocpp ? null,
  strutcpp ? null,
  tinycmmc ? null,
  tinygettext ? null,
  uitest ? null,
  wstsound ? null,
  xdgcpp ? null,
}:

stdenv.mkDerivation {
  pname = "pingus";
  version = "0.7.6-unstable-2025-07-21";

  src = fetchFromGitHub {
    owner = "Pingus";
    repo = "pingus";
    rev = "b0ceeeeb95428c73b1b81208211535c61acfc5d0";
    sha256 = "sha256-jQYZM7VLqbl9/+QXyswEXdGmwOq/nxRzWARvcDqNM9M=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libGL
    libGLU
    sdl2-compat
    SDL2_image
    fmt
    gtest
    libpng
    libsigcxx
    argpp
    geomcpp
    logmich
    priocpp
    strutcpp
    tinycmmc
    tinygettext
    uitest
    wstsound
    xdgcpp
  ];

  cmakeEntries = {
    WARNINGS = true;
    WERROR = true;
    BUILD_EXTRA = false;
    BUILD_TESTS = false;
  };

  doCheck = true;

  meta = {
    description = "Puzzle game with mechanics similar to Lemmings";
    homepage = "https://pingus.seul.org/";
    mainProgram = "pingus";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3;
  };
}
