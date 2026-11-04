{
  buildPerlPackage,
  fetchurl,
  lib,
  DateTimeFormatBuilder,
  ListMoreUtils,
  ModulePluggable,
  TestException,
  TestMockTime,
  TestNoWarnings,
}:
buildPerlPackage {
  pname = "DateTime-Format-Flexible";
  version = "0.34";

  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TH/THINC/DateTime-Format-Flexible-0.34.tar.gz";
    hash = "sha256-g2rvXSXm/4gnMIpDv/dBkeXSAiDao9ISAFC8w0FI/PE=";
  };

  propagatedBuildInputs = [
    DateTimeFormatBuilder
    ListMoreUtils
    ModulePluggable
  ];

  buildInputs = [
    TestException
    TestMockTime
    TestNoWarnings
  ];

  meta = {
    description = "Flexibly parse strings and turn them into DateTime objects";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
