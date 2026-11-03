{
  lib,
  sdl2-compat,
  autoreconfHook,
  fetchFromGitHub,
  freetype,
  pango,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdl2-pango";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "markuskimius";
    repo = "SDL2_Pango";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8SL5ylxi87TuKreC8m2kxlLr8rcmwYYvwkp4vQZ9dkc=";
  };

  nativeBuildInputs = [
    sdl2-compat
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    sdl2-compat
    freetype
    pango
  ];

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/markuskimius/SDL2_Pango";
    description = "Library for graphically rendering internationalized and tagged text in sdl2-compat using TrueType fonts";
    license = lib.licenses.lgpl21Plus;
    inherit (sdl2-compat.meta) platforms;
  };
})
