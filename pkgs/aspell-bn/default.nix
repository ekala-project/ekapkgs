{
  lib,
  stdenv,
  fetchurl,
  aspell,
  which,
}:

stdenv.mkDerivation {
  pname = "aspell-dict-bn";
  version = "0.01.1-1";

  src = fetchurl {
    url = "mirror://gnu/aspell/dict/bn/aspell6-bn-0.01.1-1.tar.bz2";
    sha256 = "1nc02jd67iggirwxnhdvlvaqm0xfyks35c4psszzj3dhzv29qgxh";
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
    description = "Aspell dictionary for Bengali";
    homepage = "http://ftp.gnu.org/gnu/aspell/dict/0index.html";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
  };
}
