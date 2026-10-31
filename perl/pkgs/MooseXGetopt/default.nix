{
  buildPerlModule,
  fetchurl,
  lib,
  ModuleBuildTiny,
  PathTiny,
  TestDeep,
  TestFatal,
  TestNeeds,
  TestTrap,
  TestWarnings,
  GetoptLongDescriptive,
  MooseXRoleParameterized,
}:
buildPerlModule {
  pname = "MooseX-Getopt";
  version = "0.76";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Getopt-0.76.tar.gz";
    hash = "sha256-/4cxvSsd+DNH37av6coVwE0uzYsojleT0JXq+Va2sCg=";
  };
  buildInputs = [
    ModuleBuildTiny
    PathTiny
    TestDeep
    TestFatal
    TestNeeds
    TestTrap
    TestWarnings
  ];
  propagatedBuildInputs = [
    GetoptLongDescriptive
    MooseXRoleParameterized
  ];
  meta = {
    description = "Moose role for processing command line options";
    homepage = "https://github.com/moose/MooseX-Getopt";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
