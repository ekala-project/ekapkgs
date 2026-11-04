{
  buildPerlModule,
  fetchurl,
  lib,
  DateTimeEventICal,
}:
buildPerlModule {
  pname = "DateTime-Format-ICal";
  version = "0.09";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-Format-ICal-0.09.tar.gz";
    hash = "sha256-iwn2U59enA3w5hNQMWme1O+e74Fl/ICu/uzIF++ZfDM=";
  };

  propagatedBuildInputs = [ DateTimeEventICal ];

  meta = {
    description = "Parse and format iCal datetime and duration strings";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
