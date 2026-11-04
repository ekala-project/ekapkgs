{
  buildPerlPackage,
  fetchurl,
  lib,
  PathTiny,
  XMLParser,
}:
buildPerlPackage {
  pname = "XML-XPath";
  version = "1.48";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MA/MANWAR/XML-XPath-1.48.tar.gz";
    hash = "sha256-e8db42sjnlsucAqVcNK1O0MJPUZ/Kr5qdD+f+Qk3kM0=";
  };

  buildInputs = [ PathTiny ];

  propagatedBuildInputs = [ XMLParser ];

  meta = {
    description = "Parse and evaluate XPath statements";
    license = lib.licenses.artistic2;
    mainProgram = "xpath";
  };
}
