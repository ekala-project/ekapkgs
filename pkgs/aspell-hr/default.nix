{
  lib,
  stdenv,
  fetchurl,
  aspell,
  which,
}:

stdenv.mkDerivation {
  pname = "aspell-dict-hr";
  version = "0.51-0";

  src = fetchurl {
    url = "mirror://gnu/aspell/dict/hr/aspell-hr-0.51-0.tar.bz2";
    sha256 = "09aafyf1vqhaxvcf3jfzf365k394b5pf0iivsr2ix5npah1h7i1a";
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
    description = "Aspell dictionary for Croatian";
    homepage = "http://ftp.gnu.org/gnu/aspell/dict/0index.html";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.all;
  };
}
