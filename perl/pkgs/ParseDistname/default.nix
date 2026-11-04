{
  buildPerlPackage,
  fetchurl,
  lib,
  ExtUtilsMakeMakerCPANfile,
  TestDifferences,
  TestUseAllModules,
}:
buildPerlPackage {
  pname = "Parse-Distname";
  version = "0.05";

  src = fetchurl {
    url = "mirror://cpan/authors/id/I/IS/ISHIGAKI/Parse-Distname-0.05.tar.gz";
    hash = "sha256-pfqTvsLat22IPaEtTzRLc7+L6wzEtmwkN28+Dzh67wc=";
  };

  buildInputs = [
    ExtUtilsMakeMakerCPANfile
    TestDifferences
    TestUseAllModules
  ];

  meta = {
    description = "Parse a distribution name";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
