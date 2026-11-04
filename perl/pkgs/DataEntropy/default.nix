{
  buildPerlPackage,
  fetchurl,
  lib,
  CryptRijndael,
  CryptURandom,
  DataFloat,
  DevelDeprecate,
  ParamsClassify,
}:
buildPerlPackage {
  pname = "Data-Entropy";
  version = "0.010";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RR/RRWO/Data-Entropy-0.010.tar.gz";
    hash = "sha256-0M8s2wKCAuidw2K42Qtw00WFApOwGQDZoYgqDG8g+Dc=";
  };
  propagatedBuildInputs = [
    CryptRijndael
    CryptURandom
    DataFloat
    DevelDeprecate
    ParamsClassify
  ];
  meta = {
    description = "Entropy (randomness) management";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
