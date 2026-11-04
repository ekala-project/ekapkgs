{
  buildPerlPackage,
  fetchurl,
  lib,
  AlgorithmDiff,
  ClassAccessor,
}:
buildPerlPackage {
  pname = "Array-Diff";
  version = "0.09";

  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NE/NEILB/Array-Diff-0.09.tar.gz";
    hash = "sha256-gAY5Lphh50FTfCu8kRbI5CuWLy4H6NZBov9qEcZEUHc=";
  };

  propagatedBuildInputs = [
    AlgorithmDiff
    ClassAccessor
  ];

  meta = {
    description = "Find the differences between two arrays";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
