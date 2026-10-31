{
  buildPerlPackage,
  fetchurl,
  lib,
  TestDeep,
  HTTPMessage,
}:
buildPerlPackage {
  pname = "HTTP-Body";
  version = "1.23";
  src = fetchurl {
    url = "mirror://cpan/authors/id/G/GE/GETTY/HTTP-Body-1.23.tar.gz";
    hash = "sha256-7OmB9BYWNaL7piFdAlcZXlOMTyNDhFMFAd/bahvY1jY=";
  };
  buildInputs = [ TestDeep ];
  propagatedBuildInputs = [ HTTPMessage ];
  meta = {
    description = "HTTP Body Parser";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
