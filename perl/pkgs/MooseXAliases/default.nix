{
  buildPerlPackage,
  fetchurl,
  lib,
  Moose,
  TestFatal,
}:
buildPerlPackage {
  pname = "MooseX-Aliases";
  version = "0.11";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DO/DOY/MooseX-Aliases-0.11.tar.gz";
    hash = "sha256-xIUPlyQmw0R6ru2Ny0Az6ERgylFwWtPqeLY6+Rn+B0g=";
  };

  buildInputs = [ TestFatal ];

  propagatedBuildInputs = [ Moose ];

  meta = {
    description = "Easy aliasing of methods and attributes in Moose";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
