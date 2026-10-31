{
  buildPerlPackage,
  fetchurl,
  CryptDES,
}:
buildPerlPackage {
  pname = "Crypt-DES_EDE3";
  version = "0.03";
  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TI/TIMLEGGE/Crypt-DES_EDE3-0.03.tar.gz";
    hash = "sha256-KFktt7njR0WqkfPhnl27uDqvRyop5we5eR0NArPiJ/U=";
  };
  propagatedBuildInputs = [ CryptDES ];
  meta = {
    description = "Triple-DES EDE encryption/decryption";
  };
}
