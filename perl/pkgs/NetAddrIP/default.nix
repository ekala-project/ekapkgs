{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "NetAddr-IP";
  version = "4.079";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MIKER/NetAddr-IP-4.079.tar.gz";
    hash = "sha256-7FqC37cCi80ouz1Wn5XYfdQWbMGYZ/IYTtOln21soOc=";
  };
  meta = {
    description = "Manages IPv4 and IPv6 addresses and subnets";
  };
}
