{
  buildPerlPackage,
  fetchurl,
  lib,
  FileSlurper,
  TestDifferences,
  TextDiff,
}:
buildPerlPackage {
  pname = "Pod-POM";
  version = "2.01";
  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NE/NEILB/Pod-POM-2.01.tar.gz";
    hash = "sha256-G1D7qbvd4+rRkr7roOrd0MYU46+xdD+m//gF9XxW9/Q=";
  };
  buildInputs = [
    FileSlurper
    TestDifferences
    TextDiff
  ];
  meta = {
    description = "POD Object Model";
    homepage = "https://github.com/neilb/Pod-POM";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "pom2";
  };
}
