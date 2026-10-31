{
  buildPerlPackage,
  fetchurl,
  HTMLTree,
  XMLXPathEngine,
}:
buildPerlPackage {
  pname = "HTML-TreeBuilder-XPath";
  version = "0.14";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MIROD/HTML-TreeBuilder-XPath-0.14.tar.gz";
    hash = "sha256-Jeu9skRKClma5eekV9deCe/N8yZqXFcAsUA8y3SIpPM=";
  };
  propagatedBuildInputs = [
    HTMLTree
    XMLXPathEngine
  ];
  meta = {
    description = "Add XPath support to HTML::TreeBuilder";
  };
}
