{
  buildPerlPackage,
  fetchurl,
  lib,
  CGI,
}:
buildPerlPackage {
  pname = "CGI-FormBuilder";
  version = "3.10";
  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BI/BIGPRESH/CGI-FormBuilder-3.10.tar.gz";
    hash = "sha256-rsmb4MDwZ6fnJpxTeOWubI1905s2i08SwNhGOxPucZg=";
  };
  propagatedBuildInputs = [ CGI ];
  meta = {
    description = "Easily generate and process stateful forms";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
