{
  lib,
  stdenv,
  fetchurl,
  aspell,
  which,
}:

stdenv.mkDerivation {
  pname = "aspell-dict-en";
  version = "2020.12.07-0";

  src = fetchurl {
    url = "mirror://gnu/aspell/dict/en/aspell6-en-2020.12.07-0.tar.bz2";
    sha256 = "1cwzqkm8gr1w51rpckwlvb43sb0b5nbwy7s8ns5vi250515773sc";
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
    description = "Aspell dictionary for English";
    license = with lib.licenses; [
      free
      publicDomain
      bsdOriginalUC
    ];
    platforms = lib.platforms.all;
  };
}
