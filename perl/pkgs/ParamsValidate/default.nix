{
  buildPerlModule,
  fetchurl,
  lib,
  TestFatal,
  TestRequires,
  ModuleImplementation,
}:
buildPerlModule {
  pname = "Params-Validate";
  version = "1.31";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DR/DROLSKY/Params-Validate-1.31.tar.gz";
    hash = "sha256-G/JRjvLEhp+RWQ4hn1RcjvEu1TzzE+DrVwSt9/Gylh4=";
  };
  buildInputs = [
    TestFatal
    TestRequires
  ];
  propagatedBuildInputs = [ ModuleImplementation ];
  meta = {
    description = "Validate method/function parameters";
    license = lib.licenses.artistic2;
  };
}
