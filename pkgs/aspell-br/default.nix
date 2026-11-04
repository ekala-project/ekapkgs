{
  lib,
  stdenv,
  fetchurl,
  aspell,
  which,
}:

stdenv.mkDerivation {
  pname = "aspell-dict-br";
  version = "0.50-2";

  src = fetchurl {
    url = "mirror://gnu/aspell/dict/br/aspell-br-0.50-2.tar.bz2";
    sha256 = "0fradnm8424bkq9a9zhpl2132dk7y95xmw45sy1c0lx6rinjl4n2";
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
    description = "Aspell dictionary for Breton";
    homepage = "http://ftp.gnu.org/gnu/aspell/dict/0index.html";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
  };
}
