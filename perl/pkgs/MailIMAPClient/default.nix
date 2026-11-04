{
  buildPerlPackage,
  fetchurl,
  lib,
  ParseRecDescent,
}:
buildPerlPackage {
  pname = "Mail-IMAPClient";
  version = "3.43";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PL/PLOBBES/Mail-IMAPClient-3.43.tar.gz";
    hash = "sha256-CTyX+sFbR6j+TSk27y3zd6v3fMirdAktISi7lF0ftG8=";
  };

  propagatedBuildInputs = [ ParseRecDescent ];

  meta = {
    description = "IMAP Client API";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
