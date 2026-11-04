{
  buildPerlPackage,
  fetchurl,
  lib,
  CacheSimpleTimedExpiry,
  ClassAccessor,
  ClassReturnValue,
  Clone,
  DBIxDBSchema,
  Want,
  capitalization,
  DBDSQLite,
}:
buildPerlPackage rec {
  pname = "DBIx-SearchBuilder";
  version = "1.85";
  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BP/BPS/DBIx-SearchBuilder-${version}.tar.gz";
    hash = "sha256-5iqwesIdGH5QRGkuSq2BaexO8u980ehxTrREoWpwOPc=";
  };
  buildInputs = [ DBDSQLite ];
  propagatedBuildInputs = [
    CacheSimpleTimedExpiry
    ClassAccessor
    ClassReturnValue
    Clone
    DBIxDBSchema
    Want
    capitalization
  ];
  meta = {
    description = "Encapsulate SQL queries and rows in simple perl objects";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
