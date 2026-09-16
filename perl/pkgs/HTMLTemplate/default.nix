{
  buildPerlPackage,
  fetchurl,
  CGI,
  TestPod,
}:
buildPerlPackage {
  pname = "HTML-Template";
  version = "2.97";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SA/SAMTREGAR/HTML-Template-2.97.tar.gz";
    hash = "sha256-ZUevYfOqhXk/hhYZCTjWd9eZX7O3IMFiWAQLyTXiEp8=";
  };
  propagatedBuildInputs = [ CGI ];
  buildInputs = [ TestPod ];
  meta = {
    description = "Perl module to use HTML-like templating language";
  };
}
