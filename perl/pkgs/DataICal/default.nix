{
  buildPerlPackage,
  fetchurl,
  lib,
  TestLongString,
  TestNoWarnings,
  TestWarn,
  ClassReturnValue,
  TextvFileasData,
}:
buildPerlPackage {
  pname = "Data-ICal";
  version = "0.24";
  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BP/BPS/Data-ICal-0.24.tar.gz";
    hash = "sha256-czHHyEiGxTM3wNuCNhXg5xNKjxPv0oTlwgcm1bzVLf8=";
  };
  buildInputs = [
    TestLongString
    TestNoWarnings
    TestWarn
  ];
  propagatedBuildInputs = [
    ClassReturnValue
    TextvFileasData
  ];
  meta = {
    description = "Generates iCalendar (RFC 2445) calendar files";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
