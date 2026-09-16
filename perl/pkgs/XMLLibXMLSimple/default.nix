{
  buildPerlPackage,
  fetchurl,
  XMLLibXML,
}:
buildPerlPackage {
  pname = "XML-LibXML-Simple";
  version = "1.01";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MA/MARKOV/XML-LibXML-Simple-1.01.tar.gz";
    hash = "sha256-zZjIEEtw12cr+ia0UTt4rfK0uSIOWGqovrGlCFADZaY=";
  };
  propagatedBuildInputs = [ XMLLibXML ];
}
