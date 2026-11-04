{
  buildPerlPackage,
  fetchurl,
  HTTPServerSimple,
}:
buildPerlPackage {
  pname = "HTTP-Server-Simple-PSGI";
  version = "0.16";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/HTTP-Server-Simple-PSGI-0.16.tar.gz";
    hash = "sha256-X3zLhFMEO5cnhJKnVzKBFuEeA1LyhUooqcY05ukTHbo=";
  };
  propagatedBuildInputs = [ HTTPServerSimple ];
  meta = {
    description = "Perl Web Server Gateway Interface Specification";
  };
}
