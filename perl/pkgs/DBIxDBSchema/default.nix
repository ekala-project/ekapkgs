{
  buildPerlPackage,
  fetchurl,
  lib,
  DBI,
}:
buildPerlPackage {
  pname = "DBIx-DBSchema";
  version = "0.47";
  src = fetchurl {
    url = "mirror://cpan/authors/id/I/IV/IVAN/DBIx-DBSchema-0.47.tar.gz";
    hash = "sha256-7u4hDcFKjWPrAawtZsZ6HcJ5+Sib6WphckyJUXkcUhI=";
  };
  propagatedBuildInputs = [ DBI ];
  meta = {
    description = "Database-independent schema objects";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
