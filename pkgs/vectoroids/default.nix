{
  lib,
  stdenv,
  fetchurl,
  sdl2-compat,
  SDL2_image,
  SDL2_mixer,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vectoroids";
  version = "1.1.2";

  src = fetchurl {
    url = "https://tuxpaint.org/ftp/unix/x/vectoroids/src/vectoroids-${finalAttrs.version}.tar.gz";
    hash = "sha256-aLV4rrNuLKODYGD+0UBAQeQKKCNlFOX2g5CcjjkCWyQ=";
  };

  buildInputs = [
    sdl2-compat
    SDL2_image
    SDL2_mixer
  ];

  preConfigure = ''
    sed -i s,/usr/local,$out, Makefile
    mkdir -p $out/bin
  '';

  meta = {
    homepage = "http://www.newbreedsoftware.com/vectoroids/";
    description = "Clone of the classic arcade game Asteroids by Atari";
    mainProgram = "vectoroids";
    license = lib.licenses.gpl2Plus;
    inherit (sdl2-compat.meta) platforms;
  };
})
