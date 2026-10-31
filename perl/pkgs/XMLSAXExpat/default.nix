{
  buildPerlPackage,
  fetchurl,
  lib,
  XMLParser,
  XMLSAX,
}:
buildPerlPackage {
  pname = "XML-SAX-Expat";
  version = "0.51";
  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BJ/BJOERN/XML-SAX-Expat-0.51.tar.gz";
    hash = "sha256-TAFiE9DOfbLElOMAhrWZF7MC24wpLc0h853uvZeAyD8=";
  };
  propagatedBuildInputs = [
    XMLParser
    XMLSAX
  ];
  installTargets = [ "pure_install" ];
  meta = {
    description = "SAX Driver for Expat";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
