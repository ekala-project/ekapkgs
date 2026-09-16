{
  buildPerlPackage,
  fetchurl,
  AuthenSimple,
  HTTPServerSimple,
}:
buildPerlPackage {
  pname = "HTTP-Server-Simple-Authen";
  version = "0.04";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/HTTP-Server-Simple-Authen-0.04.tar.gz";
    hash = "sha256-Ld3Iq53ImGmAFR5LqDamu/CR9Fzxlb4XaOvbSpk+1Zs=";
  };
  propagatedBuildInputs = [
    AuthenSimple
    HTTPServerSimple
  ];
  meta = {
    description = "Authentication plugin for HTTP::Server::Simple";
  };
}
