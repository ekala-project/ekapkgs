{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Want";
  version = "0.29";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RO/ROBIN/Want-0.29.tar.gz";
    hash = "sha256-tOR0C41Mt4NZEnPGNr1oMEiS4o2J6Iq/knOx3hf1Uvc=";
  };
  meta = {
    description = "Generalisation of wantarray";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
