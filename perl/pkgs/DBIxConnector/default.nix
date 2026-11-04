{
  buildPerlPackage,
  fetchurl,
  lib,
  DBI,
  TestMockModule,
}:
buildPerlPackage {
  pname = "DBIx-Connector";
  version = "0.59";

  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AR/ARISTOTLE/DBIx-Connector-0.59.tar.gz";
    hash = "sha256-eCmU8T9JVVhAU4SU+EBrC/JVj1M8zahsjSuV4jAQh/Q=";
  };

  buildInputs = [ TestMockModule ];

  propagatedBuildInputs = [ DBI ];

  meta = {
    description = "Fast, safe DBI connection and transaction management";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
