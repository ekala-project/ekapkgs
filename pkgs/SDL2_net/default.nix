{
  lib,
  sdl2-compat,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  # Boolean flags
  enableSdltest ? (!stdenv.hostPlatform.isDarwin),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL2_net";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_net";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-sEcKn/apA6FcR7ijb7sfuvP03ZdVfjkNZTXsasK8fAI=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    sdl2-compat
    pkg-config
  ];

  propagatedBuildInputs = [ sdl2-compat ];

  configureFlags = [
    (lib.enableFeature false "examples") # can't find libSDL2_test.a
    (lib.enableFeature enableSdltest "sdltest")
  ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/libsdl-org/SDL_net";
    description = "SDL multiplatform networking library";
    license = lib.licenses.zlib;
    inherit (sdl2-compat.meta) platforms;
  };
})
