{
  buildPerlPackage,
  fetchurl,
  lib,
  CPANDistnameInfo,
  URI,
}:
buildPerlPackage {
  pname = "URI-cpan";
  version = "1.009";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/URI-cpan-1.009.tar.gz";
    hash = "sha256-JFV5sCW2P1d8cndDARmEcjhxykDcNezsjq05riSkjhI=";
  };
  propagatedBuildInputs = [
    CPANDistnameInfo
    URI
  ];
  meta = {
    description = "URLs that refer to things on the CPAN";
    homepage = "https://github.com/rjbs/URI-cpan";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
