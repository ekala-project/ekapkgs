{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Regexp-IPv6";
  version = "0.03";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SA/SALVA/Regexp-IPv6-0.03.tar.gz";
    hash = "sha256-1ULRfXXOk2Md6LohVtoOC1inVcQJzUoNJ6OHOiZxLOI=";
  };
  meta = {
    description = "Regular expression for IPv6 addresses";
  };
}
