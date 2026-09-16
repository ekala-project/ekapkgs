{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Business-ISSN";
  version = "1.005";
  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BD/BDFOY/Business-ISSN-1.005.tar.gz";
    hash = "sha256-OwmwJn8KZmD7krb1DEx3lu9qJjtirTu+qgcYmgx8ObM=";
  };
}
