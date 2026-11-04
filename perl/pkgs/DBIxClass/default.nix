{
  buildPerlPackage,
  fetchurl,
  lib,
  DBDSQLite,
  TestDeep,
  TestException,
  TestWarn,
  ClassAccessorGrouped,
  ClassC3Componentised,
  ConfigAny,
  ContextPreserve,
  DBI,
  DataDumperConcise,
  DataPage,
  DevelGlobalDestruction,
  ModuleFind,
  PathClass,
  SQLAbstractClassic,
  ScopeGuard,
  SubName,
  namespaceclean,
}:
buildPerlPackage {
  pname = "DBIx-Class";
  version = "0.082843";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RI/RIBASUSHI/DBIx-Class-0.082843.tar.gz";
    hash = "sha256-NB4Lbssp2MSRdKbAnXxtvzhym6QBXuf9cDYKT/7h8lE=";
  };

  buildInputs = [
    DBDSQLite
    TestDeep
    TestException
    TestWarn
  ];

  propagatedBuildInputs = [
    ClassAccessorGrouped
    ClassC3Componentised
    ConfigAny
    ContextPreserve
    DBI
    DataDumperConcise
    DataPage
    DevelGlobalDestruction
    ModuleFind
    PathClass
    SQLAbstractClassic
    ScopeGuard
    SubName
    namespaceclean
  ];

  meta = {
    description = "Extensible and flexible object <-> relational mapper";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
