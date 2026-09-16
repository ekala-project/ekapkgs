{
  buildPerlPackage,
  fetchurl,
  lib,
  openssl,
  CryptOpenSSLBignum,
  CryptOpenSSLRandom,
  CryptOpenSSLGuess,
}:
buildPerlPackage {
  pname = "Crypt-OpenSSL-RSA";
  version = "0.41";
  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TI/TIMLEGGE/Crypt-OpenSSL-RSA-0.41.tar.gz";
    hash = "sha256-gvqDmJe4jpwkW2Jl874m07yHnK5MeoFR+tSjB8M2aCI=";
  };
  propagatedBuildInputs = [
    CryptOpenSSLBignum
    CryptOpenSSLRandom
  ];
  env.NIX_CFLAGS_COMPILE = "-I${openssl.dev}/include";
  env.NIX_CFLAGS_LINK = "-L${lib.getLib openssl}/lib -lcrypto";
  env.OPENSSL_PREFIX = openssl;
  buildInputs = [ CryptOpenSSLGuess ];
  meta = {
    description = "RSA encoding and decoding, using the openSSL libraries";
  };
}
