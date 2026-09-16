{
  buildPerlPackage,
  fetchurl,
  CryptOpenSSLRSA,
  CryptX,
  MailAuthenticationResults,
  MailTools,
  NetDNS,
  NetDNSResolverMock,
  TestRequiresInternet,
  YAMLLibYAML,
}:
buildPerlPackage {
  pname = "Mail-DKIM";
  version = "1.20230911";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MB/MBRADSHAW/Mail-DKIM-1.20230911.tar.gz";
    hash = "sha256-kecxcoK3JM+9LJtuZjDvFDKISLb8UgPv1w3sL7hyaMo=";
  };
  propagatedBuildInputs = [
    CryptOpenSSLRSA
    CryptX
    MailAuthenticationResults
    MailTools
    NetDNS
  ];
  doCheck = false;
  buildInputs = [
    NetDNSResolverMock
    TestRequiresInternet
    YAMLLibYAML
  ];
  meta = {
    description = "Signs/verifies Internet mail with DKIM/DomainKey signatures";
  };
}
