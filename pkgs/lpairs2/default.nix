{
  lib,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
  directoryListingUpdater,
  fetchurl,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lpairs2";
  version = "2.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/lgames/lpairs2-${finalAttrs.version}.tar.gz";
    hash = "sha256-y4eRLWhfI4XMBtGCqdM/l69pftGGIbVjVEkz/v5ytZI=";
  };

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://lgames.sourceforge.net/LPairs/";
    description = "Matching the pairs - a typical Memory Game";
    license = lib.licenses.gpl2Plus;
    mainProgram = "lpairs2";
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
