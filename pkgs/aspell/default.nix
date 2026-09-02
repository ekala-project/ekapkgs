{
  lib,
  stdenv,
  fetchurl,
  fetchzip,
  perl,
  ncurses,
  searchNixProfiles ? true,
}:

let
  devaMapsSource = fetchzip {
    name = "aspell-u-deva";
    url = "https://ftp.gnu.org/gnu/aspell/dict/mr/aspell6-mr-0.10-0.tar.bz2";
    sha256 = "1v8cdl8x2j1d4vbvsq1xrqys69bbccd6mi03fywrhkrrljviyri1";
  };
in

stdenv.mkDerivation rec {
  pname = "aspell";
  version = "0.60.8.2";

  src = fetchurl {
    url = "mirror://gnu/aspell/aspell-${version}.tar.gz";
    hash = "sha256-V/5IY+rmBI9yJFqFdbRLcY+4XKFLn4wK/EGyVN/XaRk=";
  };

  patches = lib.optional searchNixProfiles ./data-dirs-from-nix-profiles.patch;

  postPatch = ''
    patch interfaces/cc/aspell.h < ${./clang.patch}
  '';

  nativeBuildInputs = [ perl ];
  buildInputs = [
    ncurses
    perl
  ];

  doCheck = true;

  preConfigure = ''
    configureFlagsArray=(
      --enable-pkglibdir=$out/lib/aspell
      --enable-pkgdatadir=$out/lib/aspell
    );
  '';

  postInstall = ''
    cp ${devaMapsSource}/u-deva.{cmap,cset} $out/lib/aspell/
  '';

  meta = {
    description = "Spell checker for many languages";
    homepage = "http://aspell.net/";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.all;
  };
}
