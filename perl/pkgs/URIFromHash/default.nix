{
  buildPerlPackage,
  fetchurl,
  lib,
  TestFatal,
  ParamsValidate,
  URI,
}:
buildPerlPackage {
  pname = "URI-FromHash";
  version = "0.05";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DR/DROLSKY/URI-FromHash-0.05.tar.gz";
    hash = "sha256-p8rFvM7p8uLYrQ9gVAAWNxLNCsZN8vuDT3YPtJ8vb9A=";
  };
  propagatedBuildInputs = [
    ParamsValidate
    URI
  ];
  buildInputs = [ TestFatal ];
  meta = {
    description = "Build a URI from a set of named parameters";
    license = lib.licenses.artistic2;
  };
}
