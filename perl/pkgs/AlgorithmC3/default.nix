{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Algorithm-C3";
  version = "0.11";
  src = fetchurl {
    url = "mirror://cpan/authors/id/H/HA/HAARG/Algorithm-C3-0.11.tar.gz";
    hash = "sha256-qvSEZ3Zd7qbkgFS8fUPkbk1Ay82hZVLGKdN74Jgokwk=";
  };
  meta = {
    description = "Module for merging hierarchies using the C3 algorithm";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
