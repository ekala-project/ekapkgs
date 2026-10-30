{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "TermReadKey";
  version = "2.38";

  src = fetchurl {
    url = "mirror://cpan/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz";
    hash = "sha256-WmRYeNxXCsM2YVgfuwkP8k684X1D6lP9IuEFqFakcpA=";
  };

  meta = {
    description = "Perl module for simple terminal control";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
