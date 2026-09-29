{
  lib,
  sdl2-compat,
  fetchurl,
  freetype,
  harfbuzz,
  libGL,
  pkg-config,
  stdenv,
  enableSdltest ? (!stdenv.hostPlatform.isDarwin),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL2_ttf";
  version = "2.24.0";

  src = fetchurl {
    url = "https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-${finalAttrs.version}.tar.gz";
    hash = "sha256-Cyvx57ZWitvbybuSRkP3nZ3tr+Bh+h7Wh9HZrE5FO/0=";
  };

  nativeBuildInputs = [
    sdl2-compat
    pkg-config
  ];

  buildInputs = [
    sdl2-compat
    freetype
    harfbuzz
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libGL
  ];

  configureFlags = [
    (lib.enableFeature false "harfbuzz-builtin")
    (lib.enableFeature false "freetype-builtin")
    (lib.enableFeature enableSdltest "sdltest")
  ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/libsdl-org/SDL_ttf";
    description = "Support for TrueType (.ttf) font files with Simple Directmedia Layer";
    license = lib.licenses.zlib;
    inherit (sdl2-compat.meta) platforms;
  };
})
