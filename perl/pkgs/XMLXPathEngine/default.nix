{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "XML-XPathEngine";
  version = "0.14";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MIROD/XML-XPathEngine-0.14.tar.gz";
    hash = "sha256-0v57y70L66FET0pzNAHnuKpSgvrUJm1Cc13XRYKy4mQ=";
  };

  meta = {
    description = "Re-usable XPath engine for DOM-like trees";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
