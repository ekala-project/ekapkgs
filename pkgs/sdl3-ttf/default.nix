{
  lib,
  stdenv,
  fetchFromGitHub,
  validatePkgConfig,
  sdl3,
  cmake,
  freetype,
  harfbuzz,
  glib,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdl3-ttf";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_ttf";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-g7LfLxs7yr7bezQWPWn8arNuPxCfYLCO4kzXmLRUUSY=";
  };

  strictDeps = true;
  doCheck = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    validatePkgConfig
  ];

  buildInputs = [
    sdl3
    freetype
    harfbuzz
    glib
  ];

  cmakeEntries = {
    SDLTTF_STRICT = true;
    SDLTTF_HARFBUZZ = true;
    SDLTTF_PLUTOSVG = false;
  };

  meta = {
    description = "SDL TrueType font library";
    homepage = "https://github.com/libsdl-org/SDL_ttf";
    changelog = "https://github.com/libsdl-org/SDL_ttf/releases/tag/${toString finalAttrs.src.tag}";
    license = lib.licenses.zlib;
    pkgConfigModules = [ "sdl3-ttf" ];
    platforms = lib.platforms.all;
  };
})
