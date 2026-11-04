{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Math-BigInt";
  version = "1.999842";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PJ/PJACKLAM/Math-BigInt-1.999842.tar.gz";
    hash = "sha256-VGAcUMaZPn7hPYw6wzRs8VpNgGMUnNu+husB5WEORnU=";
  };

  meta = {
    description = "Arbitrary size integer/float math package";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
