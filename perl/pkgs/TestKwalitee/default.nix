{
  buildPerlPackage,
  fetchurl,
  lib,
  ModuleCPANTSAnalyse,
  CPANMetaCheck,
  TestDeep,
  TestWarnings,
}:
buildPerlPackage {
  pname = "Test-Kwalitee";
  version = "1.28";

  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Test-Kwalitee-1.28.tar.gz";
    hash = "sha256-tFNs3XVbWXciMtQyXae9T7f1vlC0WF27r3WO7DBiQ6M=";
  };

  propagatedBuildInputs = [ ModuleCPANTSAnalyse ];

  buildInputs = [
    CPANMetaCheck
    TestDeep
    TestWarnings
  ];

  meta = {
    description = "Test the Kwalitee of a distribution before you release it";
    homepage = "https://github.com/karenetheridge/Test-Kwalitee";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "kwalitee-metrics";
  };
}
