{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {

  pname = "Text-Unidecode";
  version = "1.30";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SB/SBURKE/Text-Unidecode-1.30.tar.gz";
    hash = "sha256-bCTxTdwdIOJhYcIHtzyhhO7S71fwi1+y7hlubi6IscY=";
  };
  meta = {
    description = "Plain ASCII transliterations of Unicode tex";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
