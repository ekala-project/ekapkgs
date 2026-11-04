{
  buildPerlPackage,
  fetchurl,
  lib,
  FileShareDirInstall,
  JSONMaybeXS,
  TestDifferences,
  TestException,
  XMLWriter,
  YAML,
  CarpClan,
  DBI,
  FileShareDir,
  Moo,
  PackageVariant,
  ParseRecDescent,
  TryTiny,
  GraphViz,
  GD,
}:
buildPerlPackage {
  pname = "SQL-Translator";
  version = "1.63";

  src = fetchurl {
    url = "mirror://cpan/authors/id/V/VE/VEESH/SQL-Translator-1.63.tar.gz";
    hash = "sha256-WIWwTJNJi+MqGX3JcjlHUdXeYJNBiTqWZW3oikJgMTM=";
  };

  buildInputs = [
    FileShareDirInstall
    JSONMaybeXS
    TestDifferences
    TestException
    XMLWriter
    YAML
  ];

  propagatedBuildInputs = [
    CarpClan
    DBI
    FileShareDir
    Moo
    PackageVariant
    ParseRecDescent
    TryTiny
    GraphViz
    GD
  ];

  postPatch = ''
    patchShebangs script
  '';

  meta = {
    description = "SQL DDL transformations and more";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "sqlt";
  };
}
