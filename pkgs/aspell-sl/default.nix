{
  lib,
  stdenv,
  fetchurl,
  aspell,
  which,
}:

stdenv.mkDerivation {
  pname = "aspell-dict-sl";
  version = "0.50-0";

  src = fetchurl {
    url = "mirror://gnu/aspell/dict/sl/aspell-sl-0.50-0.tar.bz2";
    sha256 = "1l9kc5g35flq8kw9jhn2n0bjb4sipjs4qkqzgggs438kywkx2rp5";
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
    description = "Aspell dictionary for Slovenian";
    homepage = "http://ftp.gnu.org/gnu/aspell/dict/0index.html";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
  };
}
