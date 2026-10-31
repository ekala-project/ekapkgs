{
  buildPerlPackage,
  fetchurl,
  lib,
  TestException,
  TestNoWarnings,
}:
buildPerlPackage {
  pname = "CGI-Simple";
  version = "1.282";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MA/MANWAR/CGI-Simple-1.282.tar.gz";
    hash = "sha256-xX8PPjLN2AYSZFFVwbgptMy+TO1lXegzq5MAWYnCfy8=";
  };
  buildInputs = [
    TestException
    TestNoWarnings
  ];
  meta = {
    description = "Simple totally OO CGI interface that is CGI.pm compliant";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
