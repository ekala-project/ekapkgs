{
  buildPerlPackage,
  fetchurl,
  lib,
  NetDNS,
}:
buildPerlPackage {
  pname = "Net-DNS-Resolver-Programmable";
  version = "0.009";

  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BI/BIGPRESH/Net-DNS-Resolver-Programmable-0.009.tar.gz";
    hash = "sha256-gICiq3dmKVhZEa8Reb23xNwr6/1LXv13sR0drGJFS/g=";
  };

  propagatedBuildInputs = [ NetDNS ];

  meta = {
    description = "Programmable DNS resolver class for offline emulation of DNS";
    homepage = "https://github.com/bigpresh/Net-DNS-Resolver-Programmable";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
