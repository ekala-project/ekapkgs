{
  buildPerlPackage,
  fetchurl,
  lib,
  openssl,
}:
buildPerlPackage {
  pname = "Crypt-OpenSSL-DSA";
  version = "0.20";
  src = fetchurl {
    url = "mirror://cpan/authors/id/K/KM/KMX/Crypt-OpenSSL-DSA-0.20.tar.gz";
    hash = "sha256-5FddeH1E5Js7Wcw57aLkYf4GBt0Oh9Opw99QEbEz5wI=";
  };
  env.NIX_CFLAGS_COMPILE = "-I${openssl.dev}/include";
  env.NIX_CFLAGS_LINK = "-L${lib.getLib openssl}/lib -lcrypto";
  meta = {
    description = "Perl interface to OpenSSL for DSA";
  };
}
