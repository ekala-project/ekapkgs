{
  buildPerlPackage,
  fetchurl,
  TestRequires,
  NetAddrIP,
}:
buildPerlPackage {
  pname = "Data-Validate-IP";
  version = "0.31";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DR/DROLSKY/Data-Validate-IP-0.31.tar.gz";
    hash = "sha256-c0r/hrb5ytQOHE2oHyj68Y4IAsdqVm2V5WE9QxgYL8E=";
  };
  buildInputs = [ TestRequires ];
  propagatedBuildInputs = [ NetAddrIP ];
  meta = {
    description = "IPv4 and IPv6 validation methods";
  };
}
