{
  buildPerlModule,
  fetchurl,
  lib,
  ModuleBuildTiny,
  TestNeeds,
  MooseXTypes,
  PathClass,
}:
buildPerlModule {
  pname = "MooseX-Types-Path-Class";
  version = "0.09";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-Path-Class-0.09.tar.gz";
    hash = "sha256-54S6tTaYrpWnCahmMwYUX/7FVmjfbPMWFTM1I/vn734=";
  };
  propagatedBuildInputs = [
    MooseXTypes
    PathClass
  ];
  buildInputs = [
    ModuleBuildTiny
    TestNeeds
  ];
  meta = {
    description = "Path::Class type library for Moose";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
