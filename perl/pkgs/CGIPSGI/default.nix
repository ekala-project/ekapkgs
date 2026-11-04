{
  buildPerlPackage,
  fetchurl,
  lib,
  CGI,
}:
buildPerlPackage {
  pname = "CGI-PSGI";
  version = "0.15";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/CGI-PSGI-0.15.tar.gz";
    hash = "sha256-xQ3LEL+EhqmEO67QMq2J2Hn/L0HJkzQt6tYvlHpZjZE=";
  };

  propagatedBuildInputs = [ CGI ];

  meta = {
    description = "Adapt CGI.pm to the PSGI protocol";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
