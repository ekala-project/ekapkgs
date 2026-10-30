{
  buildPerlPackage,
  fetchurl,
  lib,
  XMLRegExp,
  libxml_perl,
}:
buildPerlPackage {
  pname = "XML-DOM";
  version = "1.46";
  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TJ/TJMATHER/XML-DOM-1.46.tar.gz";
    hash = "sha256-i6JLC0WbAdbF5bBAiCnH1d/kf/ebNUjIE3WQSAmbF14=";
  };
  propagatedBuildInputs = [
    XMLRegExp
    libxml_perl
  ];
  meta = {
    description = "Interface to XML::DOM toolset";
    license = lib.licenses.gpl2Only;
  };
}
