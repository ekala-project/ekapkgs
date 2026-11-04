{
  lib,
  stdenv,
  fetchurl,
  aspell,
  which,
}:

stdenv.mkDerivation {
  pname = "aspell-dict-he";
  version = "1.0-0";

  src = fetchurl {
    url = "mirror://gnu/aspell/dict/he/aspell6-he-1.0-0.tar.bz2";
    sha256 = "13bhbghx5b8g0119g3wxd4n8mlf707y41vlf59irxjj0kynankfn";
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
    description = "Aspell dictionary for Hebrew";
    homepage = "http://ftp.gnu.org/gnu/aspell/dict/0index.html";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
  };
}
