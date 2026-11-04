{
  buildPerlModule,
  fetchurl,
  lib,
  ModuleBuildTiny,
  TestDeep,
  TestFatal,
  TestRequires,
  TestWithoutModule,
  MooseXTypesPathTiny,
}:
buildPerlModule {
  pname = "MooseX-ConfigFromFile";
  version = "0.14";

  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-ConfigFromFile-0.14.tar.gz";
    hash = "sha256-mtNDzZ+G1xS+m1S5xopEPYrMZQG2rWsV6coBMLLpbwg=";
  };

  buildInputs = [
    ModuleBuildTiny
    TestDeep
    TestFatal
    TestRequires
    TestWithoutModule
  ];

  propagatedBuildInputs = [ MooseXTypesPathTiny ];

  meta = {
    description = "Abstract Moose role for setting attributes from a configfile";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
