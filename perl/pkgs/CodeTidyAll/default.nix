{
  buildPerlPackage,
  fetchurl,
  lib,
  CaptureTiny,
  ConfigINI,
  FileWhich,
  Filepushd,
  IPCRun3,
  IPCSystemSimple,
  ListCompare,
  ListSomeUtils,
  LogAny,
  Moo,
  ScopeGuard,
  SpecioLibraryPathTiny,
  TextDiff,
  TimeDate,
  TimeDurationParse,
  TestClass,
  TestClassMost,
  TestDeep,
  TestDifferences,
  TestException,
  TestFatal,
  TestMost,
  TestWarn,
  TestWarnings,
  librelative,
}:
buildPerlPackage {
  pname = "Code-TidyAll";
  version = "0.84";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DR/DROLSKY/Code-TidyAll-0.84.tar.gz";
    hash = "sha256-s8AU4e3X9EBHkJjkHkeHNhBy9QE6ZqX4j5a05Tyisfc=";
  };
  propagatedBuildInputs = [
    CaptureTiny
    ConfigINI
    FileWhich
    Filepushd
    IPCRun3
    IPCSystemSimple
    ListCompare
    ListSomeUtils
    LogAny
    Moo
    ScopeGuard
    SpecioLibraryPathTiny
    TextDiff
    TimeDate
    TimeDurationParse
  ];
  buildInputs = [
    TestClass
    TestClassMost
    TestDeep
    TestDifferences
    TestException
    TestFatal
    TestMost
    TestWarn
    TestWarnings
    librelative
  ];
  meta = {
    description = "Engine for tidyall, your all-in-one code tidier and validator";
    homepage = "https://metacpan.org/release/Code-TidyAll";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "tidyall";
  };
}
