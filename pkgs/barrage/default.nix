{
  lib,
  sdl12-compat,
  SDL_mixer,
  fetchurl,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "barrage";
  version = "1.0.7";

  src = fetchurl {
    url = "mirror://sourceforge/lgames/barrage-${finalAttrs.version}.tar.gz";
    hash = "sha256-cGYrG7A4Ffh51KyR+UpeWu7A40eqxI8g4LefBIs18kg=";
  };

  postPatch = ''
    substituteInPlace src/main.c \
      --replace-fail "void refresh_screen()" "void refresh_screen(SDL_Surface *screen)"
  '';

  buildInputs = [
    sdl12-compat
    SDL_mixer
  ];

  hardeningDisable = [ "format" ];

  meta = {
    homepage = "https://lgames.sourceforge.io/Barrage/";
    description = "Destructive action game";
    license = lib.licenses.gpl2Plus;
    mainProgram = "barrage";
    inherit (sdl12-compat.meta) platforms;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
