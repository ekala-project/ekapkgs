{
  buildPerlModule,
  fetchurl,
  lib,
  TestClass,
  TestDeep,
  TestDifferences,
  TestException,
  TestMost,
  TestWarn,
}:
buildPerlModule {
  pname = "Test-Class-Most";
  version = "0.08";

  src = fetchurl {
    url = "mirror://cpan/authors/id/O/OV/OVID/Test-Class-Most-0.08.tar.gz";
    hash = "sha256-Y0ze2Gu6Xd4Hztcv+4pGcF/5OqhEuY6WveBVQCNMff8=";
  };

  buildInputs = [
    TestClass
    TestDeep
    TestDifferences
    TestException
    TestMost
    TestWarn
  ];

  meta = {
    description = "Test Classes the easy way";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
