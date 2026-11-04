{
  buildPerlPackage,
  fetchurl,
  lib,
  DevelGlobalPhase,
  PackageStash,
  TieIxHash,
  TestDeep,
  TestTrap,
}:
buildPerlPackage {
  pname = "Test-Spec";
  version = "0.54";
  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AK/AKZHAN/Test-Spec-0.54.tar.gz";
    hash = "sha256-CjHPEmXc7pC7xCRWrWC7Njr8f6xml//7D9SbupKhZdI=";
  };
  propagatedBuildInputs = [
    DevelGlobalPhase
    PackageStash
    TieIxHash
  ];
  buildInputs = [
    TestDeep
    TestTrap
  ];
  meta = {
    description = "Write tests in a declarative specification style";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
