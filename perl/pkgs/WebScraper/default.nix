{
  buildPerlModule,
  fetchurl,
  lib,
  ModuleBuildTiny,
  TestBase,
  TestRequires,
  HTMLParser,
  HTMLSelectorXPath,
  HTMLTagset,
  HTMLTree,
  HTMLTreeBuilderXPath,
  UNIVERSALrequire,
  URI,
  XMLXPathEngine,
  YAML,
  LWP,
}:
buildPerlModule {
  pname = "Web-Scraper";
  version = "0.38";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Web-Scraper-0.38.tar.gz";
    hash = "sha256-+VtuX41/7r4RbQW/WaK3zxpR7Z0wvKgBI0MOxFZ1Q78=";
  };
  buildInputs = [
    ModuleBuildTiny
    TestBase
    TestRequires
  ];
  propagatedBuildInputs = [
    HTMLParser
    HTMLSelectorXPath
    HTMLTagset
    HTMLTree
    HTMLTreeBuilderXPath
    UNIVERSALrequire
    URI
    XMLXPathEngine
    YAML
    LWP
  ];
  meta = {
    description = "Web Scraping Toolkit using HTML and CSS Selectors or XPath expressions";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
