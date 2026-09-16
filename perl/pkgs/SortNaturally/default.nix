{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Sort-Naturally";
  version = "1.03";
  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BI/BINGOS/Sort-Naturally-1.03.tar.gz";
    hash = "sha256-6qscXIdXWngmCJMEqx+P+n8Y5s2LOTdiPpmOhl7B50Y=";
  };
  meta = {
    description = "Sort lexically, but sort numeral parts numerically";
  };
}
