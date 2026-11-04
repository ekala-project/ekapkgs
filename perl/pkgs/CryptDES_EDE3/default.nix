{
  buildPerlPackage,
  fetchurl,
  lib,
  CryptDES,
}:
buildPerlPackage {
  pname = "Crypt-DES_EDE3";
  version = "0.01";

  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BT/BTROTT/Crypt-DES_EDE3-0.01.tar.gz";
    hash = "sha256-nLLgS2JenMCDPNSZ92/RJVZYPs7KeCqXWKVeP5aXSNY=";
  };

  propagatedBuildInputs = [ CryptDES ];

  meta = {
    description = "Triple-DES EDE encryption/decryption";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
