{
  buildPerlPackage,
  fetchurl,
  lib,
  CPANMetaCheck,
}:
buildPerlPackage {
  pname = "Test-CheckDeps";
  version = "0.010";

  src = fetchurl {
    url = "mirror://cpan/authors/id/L/LE/LEONT/Test-CheckDeps-0.010.tar.gz";
    hash = "sha256-ZvzMpsbzMOfsyJi9alGEbiFFs+AteMSZe6a33iO1Ue4=";
  };

  propagatedBuildInputs = [ CPANMetaCheck ];

  meta = {
    description = "Check for presence of dependencies";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
