{
  buildPerlModule,
  fetchurl,
  lib,
  ModuleBuildTiny,
  DateTimeFormatBuilder,
}:
buildPerlModule {
  pname = "DateTime-Format-Pg";
  version = "0.16014";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DM/DMAKI/DateTime-Format-Pg-0.16014.tar.gz";
    hash = "sha256-OLuWZlJNw4TDNm9jQsuWVsULrA+XFqPUTxz1Usy+Drk=";
  };

  propagatedBuildInputs = [ DateTimeFormatBuilder ];

  buildInputs = [ ModuleBuildTiny ];

  meta = {
    description = "Parse and format PostgreSQL dates and times";
    homepage = "https://github.com/lestrrat-p5/DateTime-Format-Pg";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
