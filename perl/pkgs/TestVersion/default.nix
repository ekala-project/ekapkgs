{
  buildPerlPackage,
  fetchurl,
  lib,
  TestException,
  FileFindRulePerl,
}:
buildPerlPackage {
  pname = "Test-Version";
  version = "2.09";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PL/PLICEASE/Test-Version-2.09.tar.gz";
    hash = "sha256-nOHdKJel8w4bf4lm7Gb1fY2PKA9gXyjHyiIfp5rKOOA=";
  };
  buildInputs = [ TestException ];
  propagatedBuildInputs = [ FileFindRulePerl ];
  meta = {
    description = "Check to see that version's in modules are sane";
    license = lib.licenses.artistic2;
  };
}
