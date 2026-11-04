{
  buildPerlPackage,
  fetchurl,
  lib,
  Clone,
  MathBaseConvert,
  ModuleRuntime,
  ParamsUtil,
  TestDeep,
  TextSoundex,
}:
buildPerlPackage {
  pname = "SQL-Statement";
  version = "1.414";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RE/REHSACK/SQL-Statement-1.414.tar.gz";
    hash = "sha256-3ei9z6ahNu7doGUZug8++uwIXDnbDfnEctwOxs14Gkk=";
  };

  buildInputs = [
    MathBaseConvert
    TestDeep
    TextSoundex
  ];

  propagatedBuildInputs = [
    Clone
    ModuleRuntime
    ParamsUtil
  ];

  meta = {
    description = "SQL parsing and processing engine";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
