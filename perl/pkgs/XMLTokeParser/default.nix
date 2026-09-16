{
  buildPerlPackage,
  fetchurl,
  lib,
  XMLParser,
}:
buildPerlPackage {
  pname = "XML-TokeParser";
  version = "0.05";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PO/PODMASTER/XML-TokeParser-0.05.tar.gz";
    hash = "sha256-hTm0+YQ2sabQiDQai0Uwt5IqzWUfPyk3f4sZSMfi18I=";
  };
  propagatedBuildInputs = [ XMLParser ];
  meta = {
    description = "Simplified interface to XML::Parser";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
