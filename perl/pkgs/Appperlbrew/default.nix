{
  buildPerlModule,
  fetchurl,
  lib,
  curl,
  CPANPerlReleases,
  CaptureTiny,
  DevelPatchPerl,
  PodParser,
  locallib,
  FileWhich,
  IOAll,
  ModuleBuildTiny,
  PathClass,
  TestException,
  TestNoWarnings,
  TestOutput,
  TestSpec,
  TestTempDirTiny,
}:
buildPerlModule {
  pname = "App-perlbrew";
  version = "1.00";
  src = fetchurl {
    url = "mirror://cpan/authors/id/G/GU/GUGOD/App-perlbrew-1.00.tar.gz";
    hash = "sha256-PKNFnK6f/VHef2i95CEtBx1hOLZEUo9izJDHikhSyss=";
  };
  buildInputs = [
    curl
    FileWhich
    IOAll
    ModuleBuildTiny
    PathClass
    TestException
    TestNoWarnings
    TestOutput
    TestSpec
    TestTempDirTiny
  ];
  propagatedBuildInputs = [
    CPANPerlReleases
    CaptureTiny
    DevelPatchPerl
    PodParser
    locallib
  ];
  meta = {
    description = "Manage perl installations in your $HOME";
    license = lib.licenses.mit;
    mainProgram = "perlbrew";
  };
}
