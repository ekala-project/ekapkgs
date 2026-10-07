{
  lib,
  cmake,
  sdl3,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL2_net";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_net";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-PDnkVqFOMT79wC/hlxsIQRProhIRbAIXBF6hcNKmVbI=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [ sdl3 ];

  cmakeEntries = {
    SDLNET_SAMPLES = false;
  };

  strictDeps = true;

  meta = {
    homepage = "https://github.com/libsdl-org/SDL_net";
    description = "SDL multiplatform networking library";
    license = lib.licenses.zlib;
    inherit (sdl3.meta) platforms;
  };
})
