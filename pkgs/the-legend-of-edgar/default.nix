{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPackages,
  sdl2-compat,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
  gettext,
  libpng,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "the-legend-of-edgar";
  version = "1.38";

  src = fetchFromGitHub {
    owner = "riksweeney";
    repo = "edgar";
    rev = finalAttrs.version;
    hash = "sha256-8Q2R6DrDb8ajWeewp10NlDYPPOu7HOl4LxO6DluitWQ=";
  };

  patches = [
    # https://github.com/riksweeney/edgar/pull/68
    # Rebased onto 1.38 (upstream patch targets a newer makefile layout)
    ./add-cross-compilation-support.patch
  ];

  strictDeps = true;

  depsBuildBuild = [
    buildPackages.stdenv.cc
    pkg-config
  ];
  nativeBuildInputs = [
    pkg-config
    gettext
    zlib
  ];

  buildInputs = [
    sdl2-compat
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    libpng
    zlib
  ];

  dontConfigure = true;

  makefile = "makefile";

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "BIN_DIR=${placeholder "out"}/bin/"
    "BUILD_CC=$(CC_FOR_BUILD)"
    "BUILD_PKG_CONFIG=$(PKG_CONFIG_FOR_BUILD)"
  ];


  meta = {
    homepage = "https://www.parallelrealities.co.uk/games/edgar";
    description = "2D platform game with a persistent world";
    longDescription = ''
      When Edgar's father fails to return home after venturing out one dark and
      stormy night, Edgar fears the worst: he has been captured by the evil
      sorcerer who lives in a fortress beyond the forbidden swamp.

      Donning his armour, Edgar sets off to rescue him, but his quest will not
      be easy...

      The Legend of Edgar is a platform game, not unlike those found on the
      Amiga and SNES. Edgar must battle his way across the world, solving
      puzzles and defeating powerful enemies to achieve his quest.
    '';
    license = lib.licenses.gpl1Plus;
    mainProgram = "edgar";
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
