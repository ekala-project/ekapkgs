{
  buildPerlPackage,
  fetchurl,
  lib,
  PodParser,
}:
buildPerlPackage {
  pname = "Pod-Plainer";
  version = "1.04";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RM/RMBARKER/Pod-Plainer-1.04.tar.gz";
    hash = "sha256-G7+/fR1IceWoO6shN+ItCJB4IGgVGQ6x1cEmCjSZRW8=";
  };

  propagatedBuildInputs = [ PodParser ];

  meta = {
    description = "Perl extension for converting Pod to old-style Pod";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
