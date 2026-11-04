{
  buildPerlPackage,
  fetchurl,
  lib,
  CryptURandom,
  CryptX,
}:
buildPerlPackage {
  pname = "Crypt-CBC";
  version = "3.07";

  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TI/TIMLEGGE/Crypt-CBC-3.07.tar.gz";
    hash = "sha256-9N37TdasUBPfg0G/pzTZye4PEOLnEhXsj+W/eAt8kSc=";
  };

  propagatedBuildInputs = [
    CryptURandom
    CryptX
  ];

  meta = {
    description = "Encrypt Data with Cipher Block Chaining Mode";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
