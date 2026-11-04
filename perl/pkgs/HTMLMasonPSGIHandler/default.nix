{
  buildPerlPackage,
  fetchurl,
  lib,
  CGIPSGI,
  HTMLMason,
  Plack,
}:
buildPerlPackage {
  pname = "HTML-Mason-PSGIHandler";
  version = "0.53";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RU/RUZ/HTML-Mason-PSGIHandler-0.53.tar.gz";
    hash = "sha256-6v18dlXfqCYd80RrkxooPTAwaHe4OsRnHEnP906n8As=";
  };
  buildInputs = [ Plack ];
  propagatedBuildInputs = [
    CGIPSGI
    HTMLMason
  ];
  meta = {
    description = "PSGI handler for HTML::Mason";
    homepage = "https://search.cpan.org/dist/HTML-Mason-PSGIHandler";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
