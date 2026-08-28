{
  lib,
  stdenv,
  fetchFromGitLab,
  ncurses,
  asciidoctor,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "greed";
  version = "4.5";

  src = fetchFromGitLab {
    owner = "esr";
    repo = "greed";
    tag = finalAttrs.version;
    hash = "sha256-S2K6nn4WS1gOvhlYK/UH1hfA0pzij4w5SeP004WVZik=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "-lcurses" "-lncurses" \
      --replace-fail "/usr/games/lib/greed.hs" "/var/lib/greed/greed.hs"
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs = [
    ncurses
  ];

  nativeBuildInputs = [
    asciidoctor
  ];

  meta = {
    description = "Game of Consumption";
    homepage = "http://www.catb.org/~esr/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    mainProgram = "greed";
  };
})
