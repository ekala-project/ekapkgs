{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Package-Constants";
  version = "0.06";

  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BI/BINGOS/Package-Constants-0.06.tar.gz";
    hash = "sha256-C1i+eHBszE5L2butQXZ0cEJ/17LPrXSUid4QH4W8XfU=";
  };

  meta = {
    description = "List constants defined in a package";
  };
}
