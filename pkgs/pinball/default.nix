{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libglvnd,
  libtool,
  sdl2-compat,
  SDL2_image,
  SDL2_mixer,
  libsm,
}:

stdenv.mkDerivation {
  pname = "pinball";
  version = "0.3.20230219";

  src = fetchFromGitHub {
    owner = "adoptware";
    repo = "pinball";
    rev = "7f6887d8912340c0eee7f96b4c4bb84c8d889246";
    hash = "sha256-8wuux7eC0OkgL/m20eyRGRrAF1lBGAbd7Gmid9cNPto=";
  };

  postPatch = ''
    sed -i 's/^AUTOMAKE_OPTIONS = gnu$/AUTOMAKE_OPTIONS = foreign/' Makefile.am
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    libglvnd
    libtool
    sdl2-compat
    SDL2_image
    SDL2_mixer
    libsm
  ];
  strictDeps = true;

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${lib.getDev SDL2_image}/include/sdl2-compat"
    "-I${lib.getDev SDL2_mixer}/include/sdl2-compat"
  ];

  meta = {
    homepage = "https://github.com/adoptware/pinball";
    description = "Emilia Pinball simulator";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}
