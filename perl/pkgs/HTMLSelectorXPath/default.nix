{
  buildPerlPackage,
  fetchurl,
  TestBase,
}:
buildPerlPackage {
  pname = "HTML-Selector-XPath";
  version = "0.28";
  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CO/CORION/HTML-Selector-XPath-0.28.tar.gz";
    hash = "sha256-QycX8D7Szz1kETDP09ShU/Ca1PhW2gB4E3kv4LLljQ8=";
  };
  buildInputs = [ TestBase ];
  meta = {
    description = "CSS Selector to XPath compiler";
  };
}
