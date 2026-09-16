{
  buildPerlPackage,
  fetchurl,
  lib,
  perl,
  ncurses,
}:
buildPerlPackage {
  pname = "Curses";
  version = "1.44";
  src = fetchurl {
    url = "mirror://cpan/authors/id/G/GI/GIRAFFED/Curses-1.44.tar.gz";
    hash = "sha256-ou+4x8iG1pL/xNshNhx2gJoGXliOQ/rQ1n5E751CvTA=";
  };
  preConfigure = ''
    substituteInPlace makeConfig \
      --replace '#! /usr/bin/perl' '#!${perl}/bin/perl'
  '';
  propagatedBuildInputs = [ ncurses ];
  env.NIX_CFLAGS_LINK = "-L${ncurses.out}/lib -lncurses";
  meta = {
    description = "Perl bindings to ncurses";
    license = lib.licenses.artistic1;
  };
}
