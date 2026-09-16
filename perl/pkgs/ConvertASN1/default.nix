{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Convert-ASN1";
  version = "0.34";
  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TI/TIMLEGGE/Convert-ASN1-0.34.tar.gz";
    hash = "sha256-pijXydOQVo+3Y1mXX6A/YmzlfxDcF5gOjjWH13E+Tuc=";
  };
  meta = {
    description = "ASN.1 Encode/Decode library";
  };
}
