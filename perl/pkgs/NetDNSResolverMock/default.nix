{
  buildPerlPackage,
  fetchurl,
  NetDNS,
  TestException,
}:
buildPerlPackage {
  pname = "Net-DNS-Resolver-Mock";
  version = "1.20230216";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MB/MBRADSHAW/Net-DNS-Resolver-Mock-1.20230216.tar.gz";
    hash = "sha256-7UkwV3/Rop1kNbWHVTPTso9cElijWDP+bKLLaiaFpJs=";
  };
  propagatedBuildInputs = [ NetDNS ];
  buildInputs = [ TestException ];
  meta = {
    description = "Mock a DNS Resolver object for testing";
  };
}
