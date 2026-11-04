{
  buildPerlModule,
  fetchurl,
  lib,
  DateTimeFormatBuilder,
}:
buildPerlModule {
  pname = "DateTime-Format-MySQL";
  version = "0.08";

  src = fetchurl {
    url = "mirror://cpan/authors/id/X/XM/XMIKEW/DateTime-Format-MySQL-0.08.tar.gz";
    hash = "sha256-Gctw6YWEZV41TS1qjnHMXKkC3dw6xEQWcS+RY9Eiueg=";
  };

  propagatedBuildInputs = [ DateTimeFormatBuilder ];

  meta = {
    description = "Parse and format MySQL dates and times";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
