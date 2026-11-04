{
  buildPerlPackage,
  fetchurl,
  lib,
  CGI,
  FCGI,
}:
buildPerlPackage {
  pname = "CGI-Fast";
  version = "2.16";

  src = fetchurl {
    url = "mirror://cpan/authors/id/L/LE/LEEJO/CGI-Fast-2.16.tar.gz";
    hash = "sha256-AiPX+RuAA3ud/183NgZAtx9dyNvZiaBZPV0i8/c8s9Q=";
  };

  propagatedBuildInputs = [
    CGI
    FCGI
  ];

  meta = {
    description = "CGI Interface for Fast CGI";
    homepage = "https://metacpan.org/module/CGI::Fast";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
