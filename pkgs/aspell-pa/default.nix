{
  lib,
  stdenv,
  fetchurl,
  aspell,
  which,
}:

stdenv.mkDerivation {
  pname = "aspell-dict-pa";
  version = "0.01-1";

  src = fetchurl {
    url = "mirror://gnu/aspell/dict/pa/aspell6-pa-0.01-1.tar.bz2";
    sha256 = "0if0m8xj2h68jb49ckiigph0cm6hcnpih4wy9ky7n3j4awnn5jq7";
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
    description = "Aspell dictionary for Punjabi";
    homepage = "http://ftp.gnu.org/gnu/aspell/dict/0index.html";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
  };
}
