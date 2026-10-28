{
  lib,
  stdenv,
  fetchurl,
  aspell,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aspell-dict-en";
  version = "2020.12.07-0";

  src = fetchurl {
    url = "mirror://gnu/aspell/dict/en/aspell6-en-${finalAttrs.version}.tar.bz2";
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

  meta = {
    description = "Aspell dictionary for English";
    homepage = "http://ftp.gnu.org/gnu/aspell/dict/0index.html";
    license = with lib.licenses; [
      free
      publicDomain
      bsdOriginalUC
    ];
    platforms = lib.platforms.all;
  };
})
