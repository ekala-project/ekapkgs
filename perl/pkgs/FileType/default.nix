{
  buildPerlModule,
  fetchurl,
  lib,
}:
buildPerlModule {
  pname = "File-Type";
  version = "0.22";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PM/PMISON/File-Type-0.22.tar.gz";
    hash = "sha256-01zZX+9X/U39iDH2LDTilNfEuGH8kJ4Ct2Bxc51S00E=";
  };

  meta = {
    description = "Uses magic numbers (typically at the start of a file) to determine the MIME type of that file";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
