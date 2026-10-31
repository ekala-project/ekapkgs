{
  buildPerlPackage,
  fetchurl,
  lib,
  ListMoreUtils,
  TestDifferences,
  TestException,
}:
buildPerlPackage {
  pname = "Text-Markdown";
  version = "1.000031";
  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BO/BOBTFISH/Text-Markdown-1.000031.tar.gz";
    hash = "sha256-wZHG1ezrjLdcBWUZI2BmLSAtcWutB6IzxLMppChNxxs=";
  };
  nativeCheckInputs = [
    ListMoreUtils
    TestDifferences
    TestException
  ];
  meta = {
    description = "Convert Markdown syntax to (X)HTML";
    license = lib.licenses.bsd3;
    mainProgram = "Markdown.pl";
  };
}
