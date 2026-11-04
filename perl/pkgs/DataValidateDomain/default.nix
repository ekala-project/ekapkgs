{
  buildPerlPackage,
  fetchurl,
  lib,
  Test2Suite,
  NetDomainTLD,
}:
buildPerlPackage {
  pname = "Data-Validate-Domain";
  version = "0.15";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DR/DROLSKY/Data-Validate-Domain-0.15.tar.gz";
    hash = "sha256-PJ95GHsNPHGt0fj1WbgN8VmTAKbSA+CxYcvhjhdqqzY=";
  };
  buildInputs = [ Test2Suite ];
  propagatedBuildInputs = [ NetDomainTLD ];
  meta = {
    description = "Domain and host name validation";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
