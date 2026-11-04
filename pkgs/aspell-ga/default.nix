{
  lib,
  stdenv,
  fetchurl,
  aspell,
  which,
}:

stdenv.mkDerivation {
  pname = "aspell-dict-ga";
  version = "4.5-0";

  src = fetchurl {
    url = "mirror://gnu/aspell/dict/ga/aspell5-ga-4.5-0.tar.bz2";
    sha256 = "0y869mmvfb3bzadfgajwa2rfb0xfhi6m9ydwgxkb9v2claydnps5";
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
    description = "Aspell dictionary for Irish";
    homepage = "http://ftp.gnu.org/gnu/aspell/dict/0index.html";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
  };
}
