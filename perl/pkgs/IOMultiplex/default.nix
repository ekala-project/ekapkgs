{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "IO-Multiplex";
  version = "1.16";
  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BB/BBB/IO-Multiplex-1.16.tar.gz";
    hash = "sha256-dNIsRLWtLnGQ4nhuihfXS79M74m00RV7ozWYtaJyDa0=";
  };
  meta = {
    description = "Supply object methods for locking files";
  };
}
