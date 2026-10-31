{
  buildPerlPackage,
  fetchurl,
  TestDeep,
  TestFatal,
  TestOutput,
  ClassMethodModifiers,
  ListMoreUtils,
  ModuleRuntime,
  RoleTiny,
  strictures,
}:
buildPerlPackage {
  pname = "Data-Perl";
  version = "0.002011";
  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TO/TOBYINK/Data-Perl-0.002011.tar.gz";
    hash = "sha256-jTTb4xTPotmb2arlRrvelMOLsFt0sHyJveFnOm9sVfQ=";
  };
  buildInputs = [
    TestDeep
    TestFatal
    TestOutput
  ];
  propagatedBuildInputs = [
    ClassMethodModifiers
    ListMoreUtils
    ModuleRuntime
    RoleTiny
    strictures
  ];
  meta = {
    description = "Base classes wrapping fundamental Perl data types";
  };
}
