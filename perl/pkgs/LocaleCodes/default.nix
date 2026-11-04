{
  buildPerlPackage,
  fetchurl,
  lib,
  TestInter,
}:
buildPerlPackage {
  pname = "Locale-Codes";
  version = "3.76";

  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SB/SBECK/Locale-Codes-3.76.tar.gz";
    hash = "sha256-Qo00GFUJ7fbaYoYoAJcohrsCwySTRU/L4Y+Zmk9DXzk=";
  };

  buildInputs = [ TestInter ];

  meta = {
    description = "Distribution of modules to handle locale codes";
    homepage = "https://github.com/SBECK-github/Locale-Codes";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
