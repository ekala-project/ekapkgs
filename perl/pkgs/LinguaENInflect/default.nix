{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {

  pname = "Lingua-EN-Inflect";
  version = "1.905";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DC/DCONWAY/Lingua-EN-Inflect-1.905.tar.gz";
    hash = "sha256-BcKew0guVyMTpg2iGBsLMMXbfPAfiudhatZ+G2YmMpY=";
  };
  meta = {
    description = "Convert singular to plural. Select 'a' or 'an'";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };

}
