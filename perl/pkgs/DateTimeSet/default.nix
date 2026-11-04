{
  buildPerlModule,
  fetchurl,
  lib,
  DateTime,
  ParamsValidate,
  SetInfinite,
}:
buildPerlModule {
  pname = "DateTime-Set";
  version = "0.3900";

  src = fetchurl {
    url = "mirror://cpan/authors/id/F/FG/FGLOCK/DateTime-Set-0.3900.tar.gz";
    hash = "sha256-lPQcOSSq/eTvf6a1jgWV1AONisX/1iuhEbE8X028CUY=";
  };

  propagatedBuildInputs = [
    DateTime
    ParamsValidate
    SetInfinite
  ];

  meta = {
    description = "DateTime set objects";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
