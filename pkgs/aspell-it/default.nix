{
  lib,
  stdenv,
  fetchurl,
  aspell,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aspell-dict-it";
  version = "2.2-20050523-0";

  src = fetchurl {
    url = "mirror://gnu/aspell/dict/it/aspell6-it-2.2_20050523-0.tar.bz2";
    hash = "sha256-OxnccJkkeDyNhxEaqWU9xsAA6EUYN3ir7nUCFdg6rr0=";
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
    description = "Aspell dictionary for Italian";
    homepage = "http://ftp.gnu.org/gnu/aspell/dict/0index.html";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
  };
})
