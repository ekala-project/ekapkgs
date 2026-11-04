{
  buildPerlPackage,
  fetchurl,
  lib,
  FileFindRule,
  TestPod,
  TestPodCoverage,
}:
buildPerlPackage {
  pname = "Test-Inter";
  version = "1.10";

  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SB/SBECK/Test-Inter-1.10.tar.gz";
    hash = "sha256-cewRXqwm+2aJGb1mQLQcNzInUuvUjBx222a3O679O10=";
  };

  buildInputs = [
    FileFindRule
    TestPod
    TestPodCoverage
  ];

  meta = {
    description = "Framework for more readable interactive test scripts";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
