{
  buildPerlPackage,
  fetchurl,
  RegexpIPv6,
}:
buildPerlPackage {
  pname = "Net-Whois-IP";
  version = "1.19";
  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BS/BSCHMITZ/Net-Whois-IP-1.19.tar.gz";
    hash = "sha256-8JvfoPHSZltTSCa186hmI0mTDu0pmO/k2Nv5iBMUciI=";
  };
  doCheck = false;
  postPatch = ''
    substituteInPlace IP.pm --replace " AutoLoader" ""
  '';
  buildInputs = [ RegexpIPv6 ];
  meta = {
    description = "Perl extension for looking up the whois information for ip addresses";
  };
}
