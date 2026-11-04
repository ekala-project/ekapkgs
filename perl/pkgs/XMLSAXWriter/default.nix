{
  buildPerlPackage,
  fetchurl,
  lib,
  XMLFilterBufferText,
  XMLNamespaceSupport,
  XMLSAXBase,
}:
buildPerlPackage {
  pname = "XML-SAX-Writer";
  version = "0.57";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PE/PERIGRIN/XML-SAX-Writer-0.57.tar.gz";
    hash = "sha256-PWHQfvQ7ASb1tN5PQVolb6hZ+ojcT9q6rXC3vnxoLPA=";
  };

  propagatedBuildInputs = [
    XMLFilterBufferText
    XMLNamespaceSupport
    XMLSAXBase
  ];

  meta = {
    description = "SAX2 XML Writer";
    homepage = "https://github.com/perigrin/xml-sax-writer";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
