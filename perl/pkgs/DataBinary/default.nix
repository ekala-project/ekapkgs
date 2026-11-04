{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Data-Binary";
  version = "0.01";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SN/SNKWATT/Data-Binary-0.01.tar.gz";
    hash = "sha256-SCGi3hCscQj03LKEpxuHaYGwyx6mxe1q+xd78ufLjXM=";
  };
  meta = {
    description = "Simple detection of binary versus text in strings";
    license = lib.licenses.artistic2;
  };
}
