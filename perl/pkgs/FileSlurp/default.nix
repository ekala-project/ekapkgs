{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "File-Slurp";
  version = "9999.32";
  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CA/CAPOEIRAB/File-Slurp-9999.32.tar.gz";
    hash = "sha256-TDwhmSqdQr46ed10o8g9J9OAVyadZVCaL1VeoPsrxbA=";
  };
  meta = {
    description = "Simple and Efficient Reading/Writing/Modifying of Complete Files";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
