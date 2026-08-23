{
  lib,
  SDL,
  fetchFromGitHub,
  giflib,
  xorg,
  libjpeg,
  libpng,
  libtiff,
  libwebp,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL_image";
  version = "3.4.4";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_image";
    rev = "a5eac02dacd8a8940ffccd1b8d0783c0b5f8ec7d";
    hash = "sha256-vrV12fYGSh/vtCktsUVNvcRCn5lZ2tyBYwqhLPgNdhw=";
  };

  configureFlags = [
    # Disable dynamic loading or else dlopen will fail because of no proper
    # rpath
    (lib.enableFeature false "jpg-shared")
    (lib.enableFeature false "png-shared")
    (lib.enableFeature false "tif-shared")
    (lib.enableFeature false "webp-shared")
    (lib.enableFeature (!stdenv.hostPlatform.isDarwin) "sdltest")
  ];

  nativeBuildInputs = [
    SDL
    pkg-config
  ];

  buildInputs = [
    SDL
    giflib
    xorg.libXpm
    libjpeg
    libpng
    libtiff
    libwebp
  ];

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  meta = {
    homepage = "http://www.libsdl.org/projects/SDL_image/";
    description = "SDL image library";
    license = lib.licenses.zlib;
    maintainers = [ ];
    inherit (SDL.meta) platforms;
  };
})
