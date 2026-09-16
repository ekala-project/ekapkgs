{
  buildPerlPackage,
  fetchurl,
  lib,
  openssl,
  CryptOpenSSLGuess,
}:
buildPerlPackage {
  pname = "Crypt-OpenSSL-Random";
  version = "0.15";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RU/RURBAN/Crypt-OpenSSL-Random-0.15.tar.gz";
    hash = "sha256-8IdvqhujER45uGqnMMYDIR7/KQXkYMcqV7YejPR1zvQ=";
  };
  env.NIX_CFLAGS_COMPILE = "-I${openssl.dev}/include";
  env.NIX_CFLAGS_LINK = "-L${lib.getLib openssl}/lib -lcrypto";
  env.OPENSSL_PREFIX = openssl;
  buildInputs = [ CryptOpenSSLGuess ];
  meta = {
    description = "OpenSSL/LibreSSL pseudo-random number generator access";
  };
}
