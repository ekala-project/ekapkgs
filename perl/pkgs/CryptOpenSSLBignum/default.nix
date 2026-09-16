{
  buildPerlPackage,
  fetchurl,
  lib,
  openssl,
}:
buildPerlPackage {
  pname = "Crypt-OpenSSL-Bignum";
  version = "0.09";
  src = fetchurl {
    url = "mirror://cpan/authors/id/K/KM/KMX/Crypt-OpenSSL-Bignum-0.09.tar.gz";
    hash = "sha256-I05y+4OW1FUn5v1F5DdZxcPzogjPjynmoiFhqZb9Qtw=";
  };
  env.NIX_CFLAGS_COMPILE = "-I${openssl.dev}/include";
  env.NIX_CFLAGS_LINK = "-L${lib.getLib openssl}/lib -lcrypto";
  meta = {
    description = "OpenSSL's multiprecision integer arithmetic";
  };
}
