{
  lib,
  stdenv,
  fetchurl,
  aspell,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aspell-dict-fr";
  version = "0.50-3";

  src = fetchurl {
    url = "mirror://gnu/aspell/dict/fr/aspell-fr-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-+UIQR1GdKvmnpGbkM29ubqVSBrNWzTPIvRjLYmvyzpE=";
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
    description = "Aspell dictionary for French";
    homepage = "http://ftp.gnu.org/gnu/aspell/dict/0index.html";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
  };
})
