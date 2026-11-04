{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Object-Accessor";
  version = "0.48";

  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BI/BINGOS/Object-Accessor-0.48.tar.gz";
    hash = "sha256-dsuCSie2tOVgQJ/Pb9Wzv7vTi3Lx89N+0LVL2cC66t4=";
  };

  meta = {
    description = "Per object accessors";
  };
}
