{
  buildPerlPackage,
  fetchurl,
  LWP,
}:
buildPerlPackage {
  pname = "HTTP-Proxy";
  version = "0.304";
  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BO/BOOK/HTTP-Proxy-0.304.tar.gz";
    hash = "sha256-sFKQU07HNiXCGgVl/DUXCJDasWOEPZUzHCksI/UExp0=";
  };
  propagatedBuildInputs = [ LWP ];
  doCheck = false;
  meta = {
    description = "Pure Perl HTTP proxy";
  };
}
