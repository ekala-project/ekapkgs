{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Net-IP";
  version = "1.26";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MA/MANU/Net-IP-1.26.tar.gz";
    hash = "sha256-BA8W8wZmR9dhtySjtwdU0oy9Hm/l6gHGPtHNhXEX1jk=";
  };
  meta = {
    description = "Perl extension for manipulating IPv4/IPv6 addresses";
  };
}
