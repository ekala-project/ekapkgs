{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Devel-GlobalPhase";
  version = "0.003003";

  src = fetchurl {
    url = "mirror://cpan/authors/id/H/HA/HAARG/Devel-GlobalPhase-0.003003.tar.gz";
    hash = "sha256-jaMCL3ynHf2/SqYGmJRNcgCsMUn0c32KnJG/Q4f/MvU=";
  };

  meta = {
    description = "Detect perl's global phase on older perls";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
