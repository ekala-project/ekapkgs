{
  buildPerlPackage,
  fetchurl,
  lib,
  openssl,
  PathClass,
  BytesRandomSecure,
  LWPProtocolHttps,
}:
buildPerlPackage {
  pname = "Crypt-SSLeay";
  version = "0.73_06";
  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NA/NANIS/Crypt-SSLeay-0.73_06.tar.gz";
    hash = "sha256-+OzKRch+uRMlmSsT8FlPgI5vG8TDuafxQbmoODhNJSw=";
  };
  makeMakerFlags = [
    "--libpath=${lib.getLib openssl}/lib"
    "--incpath=${openssl.dev}/include"
  ];
  buildInputs = [ PathClass ];
  propagatedBuildInputs = [
    BytesRandomSecure
    LWPProtocolHttps
  ];
  meta = {
    description = "OpenSSL support for LWP";
    license = lib.licenses.artistic2;
  };
}
