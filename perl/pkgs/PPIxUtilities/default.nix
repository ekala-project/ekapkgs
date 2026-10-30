{
  buildPerlModule,
  fetchurl,
  lib,
  ExceptionClass,
  PPI,
  Readonly,
  TestDeep,
}:
buildPerlModule {

  pname = "PPIx-Utilities";
  version = "1.001000";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/EL/ELLIOTJS/PPIx-Utilities-1.001000.tar.gz";
    hash = "sha256-A6SDOG/WosgI8Jd41E2wawLDFA+yS6S/EvhR9G07y5s=";
  };
  buildInputs = [ TestDeep ];
  propagatedBuildInputs = [
    ExceptionClass
    PPI
    Readonly
  ];
  meta = {
    description = "Extensions to PPI|PPI";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };

}
