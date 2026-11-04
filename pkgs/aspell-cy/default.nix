{
  lib,
  stdenv,
  fetchurl,
  aspell,
  which,
}:

stdenv.mkDerivation {
  pname = "aspell-dict-cy";
  version = "0.50-3";

  src = fetchurl {
    url = "mirror://gnu/aspell/dict/cy/aspell-cy-0.50-3.tar.bz2";
    sha256 = "15vq601lzz1gi311xym4bv9lv1k21xcfn50jmzamw7h6f36rsffm";
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
    description = "Aspell dictionary for Welsh";
    homepage = "http://ftp.gnu.org/gnu/aspell/dict/0index.html";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
  };
}
