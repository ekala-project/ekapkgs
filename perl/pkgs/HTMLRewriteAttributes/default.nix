{
  buildPerlPackage,
  fetchurl,
  lib,
  HTMLParser,
}:
buildPerlPackage {
  pname = "HTML-RewriteAttributes";
  version = "0.05";
  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BP/BPS/HTML-RewriteAttributes-0.06.tar.gz";
    hash = "sha256-vGQgAmEUL5pffgeG3FqySmMwvBm9Hj6btLbXwxYhtyI=";
  };
  propagatedBuildInputs = [ HTMLParser ];
  meta = {
    description = "Concise attribute rewriting";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
