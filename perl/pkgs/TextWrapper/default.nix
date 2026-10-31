{
  buildPerlPackage,
  fetchurl,
  lib,
  TestDifferences,
}:
buildPerlPackage {
  pname = "Text-Wrapper";
  version = "1.05";
  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CJ/CJM/Text-Wrapper-1.05.tar.gz";
    hash = "sha256-ZCaOFZg6nfR+HZGZpJHzlOifVC5Ur7M/S3jz8xjgmrk=";
  };
  buildInputs = [ TestDifferences ];
  meta = {
    description = "Word wrap text by breaking long lines";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
