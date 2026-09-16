{
  buildPerlPackage,
  fetchurl,
  readline,
  ncurses,
}:
buildPerlPackage {
  pname = "Term-ReadLine-Gnu";
  version = "1.47";
  src = fetchurl {
    url = "mirror://cpan/authors/id/H/HA/HAYASHI/Term-ReadLine-Gnu-1.47.tar.gz";
    hash = "sha256-OwesiptJTFCqh6QNzKs/h5uS65UnrA8t7V1HQ9Fmtkk=";
  };
  buildInputs = [
    readline
    ncurses
  ];
  env.NIX_CFLAGS_LINK = "-lreadline -lncursesw";
  env.AUTOMATED_TESTING = false;
  preConfigure = ''
    substituteInPlace Makefile.PL --replace '$Config{libpth}' \
      "'${ncurses.out}/lib'"
  '';
  doCheck = false;
  meta = {
    description = "Perl extension for the GNU Readline/History Library";
  };
}
