{
  buildPerlModule,
  fetchurl,
  lib,
  ModuleUtil,
  TestMockTimeHiRes,
  Clone,
  DateTime,
  DateTimeHiRes,
  DateTimeTimeZone,
  ListMoreUtils,
  ParamsValidate,
  boolean,
}:
buildPerlModule {
  pname = "DateTime-Format-Natural";
  version = "1.18";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SC/SCHUBIGER/DateTime-Format-Natural-1.18.tar.gz";
    hash = "sha256-2TRqRhUDVFnYvO4PrD1OuuoDj09DsoT2nt9z9u1XUf4=";
  };
  buildInputs = [
    ModuleUtil
    TestMockTimeHiRes
  ];
  propagatedBuildInputs = [
    Clone
    DateTime
    DateTimeHiRes
    DateTimeTimeZone
    ListMoreUtils
    ParamsValidate
    boolean
  ];
  meta = {
    description = "Parse informal natural language date/time strings";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "dateparse";
  };
}
