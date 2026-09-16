{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "UNIVERSAL-isa";
  version = "1.20171012";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/UNIVERSAL-isa-1.20171012.tar.gz";
    hash = "sha256-0WlWA2ywHIGd7H0pT274kb4Ltkh2mJYBNUspMWTafys=";
  };
  meta = {
    description = "Attempt to recover from people calling UNIVERSAL::isa as a function";
  };
}
