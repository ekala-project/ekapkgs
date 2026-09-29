{
  lib,
  sdl12-compat,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  # Boolean flags
  enableSdltest ? (!stdenv.hostPlatform.isDarwin),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL_net";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_net";
    rev = "e2e041b81747bc01b2c5fb3757a082e525e5d25b";
    hash = "sha256-Nk1OoCIrHMABHuPrJHMlLyyR73px/Xikgz40RpDfonw=";
  };

  nativeBuildInputs = [
    sdl12-compat
    pkg-config
  ];

  propagatedBuildInputs = [
    sdl12-compat
  ];

  configureFlags = [
    (lib.enableFeature enableSdltest "sdltest")
  ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/libsdl-org/SDL_net";
    description = "sdl12-compat networking library";
    license = lib.licenses.zlib;
    inherit (sdl12-compat.meta) platforms;
  };
})
