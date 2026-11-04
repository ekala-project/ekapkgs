{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Guard";
  version = "1.023";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/ML/MLEHMANN/Guard-1.023.tar.gz";
    hash = "sha256-NMTd+R/JPRCQ2G2hTfcG0XWxYQxnNywB4SzpVV1N0dw=";
  };
  meta = {
    description = "Safe cleanup blocks";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
