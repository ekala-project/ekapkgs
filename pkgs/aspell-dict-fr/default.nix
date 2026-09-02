{
  lib,
  stdenv,
  fetchurl,
  aspell,
  which,
}:

stdenv.mkDerivation {
  pname = "aspell-dict-fr";
  version = "0.50-3";

  src = fetchurl {
    url = "mirror://gnu/aspell/dict/fr/aspell-fr-0.50-3.tar.bz2";
    sha256 = "14ffy9mn5jqqpp437kannc3559bfdrpk7r36ljkzjalxa53i0hpr";
  };

  strictDeps = true;

  nativeBuildInputs = [
    aspell
    which
  ];

  dontAddPrefix = true;
  configurePlatforms = [ ];

  preBuild = "makeFlagsArray=(dictdir=$out/lib/aspell datadir=$out/lib/aspell)";

  postInstall = ''
    rm -f $out/lib/aspell/u-deva.{cmap,cset}
  '';

  meta = {
    description = "Aspell dictionary for French";
    homepage = "http://ftp.gnu.org/gnu/aspell/dict/0index.html";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
  };
}
