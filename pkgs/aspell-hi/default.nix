{
  lib,
  stdenv,
  fetchurl,
  aspell,
  which,
}:

stdenv.mkDerivation {
  pname = "aspell-dict-hi";
  version = "0.02-0";

  src = fetchurl {
    url = "mirror://gnu/aspell/dict/hi/aspell6-hi-0.02-0.tar.bz2";
    sha256 = "0drs374qz4419zx1lf2k281ydxf2750jk5ailafj1x0ncz27h1ys";
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
    description = "Aspell dictionary for Hindi";
    homepage = "http://ftp.gnu.org/gnu/aspell/dict/0index.html";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
  };
}
