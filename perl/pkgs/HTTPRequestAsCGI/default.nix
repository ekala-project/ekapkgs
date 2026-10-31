{
  buildPerlPackage,
  fetchurl,
  lib,
  ClassAccessor,
  HTTPMessage,
}:
buildPerlPackage {
  pname = "HTTP-Request-AsCGI";
  version = "1.2";
  src = fetchurl {
    url = "mirror://cpan/authors/id/F/FL/FLORA/HTTP-Request-AsCGI-1.2.tar.gz";
    hash = "sha256-lFv7B8bRr1J3P7eEW6YuOnQRGzXL0tXkPvgxnlWsvOo=";
  };
  propagatedBuildInputs = [
    ClassAccessor
    HTTPMessage
  ];
  meta = {
    description = "Set up a CGI environment from an HTTP::Request";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
