{
  lib,
  stdenv,
  fetchurl,
  aspell,
  which,
}:

stdenv.mkDerivation {
  pname = "aspell-dict-de";
  version = "20161207-7-0";

  src = fetchurl {
    url = "mirror://gnu/aspell/dict/de/aspell6-de-20161207-7-0.tar.bz2";
    sha256 = "0wamclvp66xfmv5wff96v6gdlnfv4y8lx3f8wvxyzm5imwgms4n2";
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
    description = "Aspell dictionary for German";
    homepage = "http://ftp.gnu.org/gnu/aspell/dict/0index.html";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
}
