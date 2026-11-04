{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Test-InDistDir";
  version = "1.112071";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MITHALDU/Test-InDistDir-1.112071.tar.gz";
    hash = "sha256-kixcYzFPQG9MuzXsQjrCFU0sK3GmWt23cyydJAqD/vs=";
  };

  meta = {
    description = "Test environment setup for development with IDE";
    license = lib.licenses.wtfpl;
  };
}
