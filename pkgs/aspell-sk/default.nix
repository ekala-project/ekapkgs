{
  lib,
  stdenv,
  fetchurl,
  aspell,
  which,
}:

stdenv.mkDerivation {
  pname = "aspell-dict-sk";
  version = "2.01-2";

  src = fetchurl {
    url = "mirror://gnu/aspell/dict/sk/aspell6-sk-2.01-2.tar.bz2";
    sha256 = "19k0m1v5pcf7xr4lxgjkzqkdlks8nyb13bvi1n7521f3i4lhma66";
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
    description = "Aspell dictionary for Slovak";
    homepage = "http://ftp.gnu.org/gnu/aspell/dict/0index.html";
    license = with lib.licenses; [
      lgpl21Only
      gpl2Only
      mpl11
    ];
    platforms = lib.platforms.all;
  };
}
