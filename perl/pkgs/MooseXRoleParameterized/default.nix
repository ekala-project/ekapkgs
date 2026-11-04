{
  buildPerlModule,
  fetchurl,
  lib,
  CPANMetaCheck,
  ModuleBuildTiny,
  TestFatal,
  TestNeeds,
  Moose,
  namespaceautoclean,
}:
buildPerlModule {
  pname = "MooseX-Role-Parameterized";
  version = "1.11";

  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Role-Parameterized-1.11.tar.gz";
    hash = "sha256-HP52bF1/Dsq1f3M9zKQwoqKs1rmVdXFBuUCt42kr7J4=";
  };

  buildInputs = [
    CPANMetaCheck
    ModuleBuildTiny
    TestFatal
    TestNeeds
  ];

  propagatedBuildInputs = [
    Moose
    namespaceautoclean
  ];

  meta = {
    description = "Moose roles with composition parameters";
    homepage = "https://github.com/moose/MooseX-Role-Parameterized";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
