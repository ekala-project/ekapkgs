{
  buildPerlPackage,
  fetchurl,
  lib,
  DataDumperConcise,
  TestDeep,
  TestException,
  TestWarn,
  HashMerge,
  MROCompat,
  Moo,
}:
buildPerlPackage {
  pname = "SQL-Abstract";
  version = "2.000001";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MS/MSTROUT/SQL-Abstract-2.000001.tar.gz";
    hash = "sha256-NaZCZiw0lCDUS+bg732HZep0PrEq0UOZqjojK7lObpo=";
  };
  buildInputs = [
    DataDumperConcise
    TestDeep
    TestException
    TestWarn
  ];
  propagatedBuildInputs = [
    HashMerge
    MROCompat
    Moo
  ];
  meta = {
    description = "Generate SQL from Perl data structures";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
