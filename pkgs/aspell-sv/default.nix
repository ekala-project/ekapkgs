{
  lib,
  stdenv,
  fetchurl,
  aspell,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aspell-dict-sv";
  version = "0.51-0";

  src = fetchurl {
    url = "mirror://gnu/aspell/dict/sv/aspell-sv-0.51-0.tar.bz2";
    hash = "sha256-m3BXPJyM929c22q837g0p1S7qh79fW9X9HuKkaGcXAo=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    aspell
    which
  ];

  dontAddPrefix = true;
  configurePlatforms = [ ];

  preBuild = "makeFlagsArray=(dictdir=$out/lib/aspell datadir=$out/lib/aspell)";

  meta = {
    description = "Aspell dictionary for Swedish";
    homepage = "http://ftp.gnu.org/gnu/aspell/dict/0index.html";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
  };
})
