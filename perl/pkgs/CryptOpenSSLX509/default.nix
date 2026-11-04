{
  buildPerlPackage,
  fetchurl,
  lib,
  openssl,
  CryptOpenSSLGuess,
  ConvertASN1,
}:
buildPerlPackage {
  pname = "Crypt-OpenSSL-X509";
  version = "2.1.3";
  src = fetchurl {
    url = "mirror://cpan/authors/id/J/JO/JONASBN/Crypt-OpenSSL-X509-2.1.3.tar.gz";
    hash = "sha256-CtllF1dGroRrBRCwOKofltLduMhg/pfOpvvcegVfn54=";
  };
  env.NIX_CFLAGS_COMPILE = "-I${openssl.dev}/include";
  env.NIX_CFLAGS_LINK = "-L${lib.getLib openssl}/lib -lcrypto";
  env.OPENSSL_PREFIX = openssl;
  buildInputs = [ CryptOpenSSLGuess ];
  propagatedBuildInputs = [ ConvertASN1 ];
  meta = {
    description = "Perl extension to OpenSSL X509 API";
  };
}
