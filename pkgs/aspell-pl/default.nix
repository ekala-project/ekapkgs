{
  lib,
  stdenv,
  fetchurl,
  aspell,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aspell-dict-pl";
  version = "6.0_20061121-0";

  src = fetchurl {
    url = "mirror://gnu/aspell/dict/pl/aspell6-pl-6.0_20061121-0.tar.bz2";
    hash = "sha256-AXdB/LcKiF1xjFNBYMneBrA8xy81KHm9EGvhZeAkV00=";
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
    description = "Aspell dictionary for Polish";
    homepage = "http://ftp.gnu.org/gnu/aspell/dict/0index.html";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
  };
})
