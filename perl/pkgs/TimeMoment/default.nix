{
  buildPerlPackage,
  fetchurl,
  lib,
  TestFatal,
  TestNumberDelta,
  TestRequires,
}:
buildPerlPackage {
  pname = "Time-Moment";
  version = "0.44";
  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CH/CHANSEN/Time-Moment-0.44.tar.gz";
    hash = "sha256-ZKz6BC9jT8742t9V5/QrpOqriq631SEuuJgVox949v0=";
  };
  buildInputs = [
    TestFatal
    TestNumberDelta
    TestRequires
  ];
  meta = {
    description = "Represents a date and time of day with an offset from UTC";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
