{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gettext,
  makeWrapper,
  bzip2,
  curl,
  libjpeg,
  libxml2,
  xz,
  lua,
  ode,
  libGL,
  libGLU,
  libpng,
  pkg-config,
  sdl2-compat,
  SDL2_mixer,
  SDL2_net,
  SDL2_ttf,
  sqlite,
  libxdg_basedir,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "xmoto";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "xmoto";
    repo = "xmoto";
    rev = "v${version}";
    hash = "sha256-DNljUd7FSH0fTgQx8LMqItZ54aLZtwMUPzqR8Z820SM=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    gettext
    makeWrapper
  ];

  buildInputs = [
    bzip2
    curl
    libjpeg
    libxml2
    xz
    lua
    ode
    libGL
    libGLU
    libpng
    sdl2-compat
    SDL2_mixer
    SDL2_net
    SDL2_ttf
    sqlite
    libxdg_basedir
    zlib
  ];

  # Should normally come from SDL2_ttf pkg-config, but xmoto does not
  # use it and uses include directories directly. Let's re-inject the
  # path here.
  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev sdl2-compat}/include/sdl2-compat";

  preFixup = ''
    wrapProgram "$out/bin/xmoto" \
      --prefix XDG_DATA_DIRS : "$out/share/"
  '';

  meta = {
    description = "Challenging 2D motocross platform game, where physics play an important role";
    mainProgram = "xmoto";
    longDescription = ''
      X-Moto is a challenging 2D motocross platform game, where physics plays an all important role in the gameplay.
      You need to control your bike to its limits, if you want to have a chance to finish the most difficult challenges.
    '';
    homepage = "https://xmoto.tuxfamily.org";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl2Plus;
  };
}
