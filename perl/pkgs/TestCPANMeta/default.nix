{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Test-CPAN-Meta";
  version = "0.25";
  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BA/BARBIE/Test-CPAN-Meta-0.25.tar.gz";
    hash = "sha256-9VtPnPa8OW0P6AJyZ2hcsqxK/86JfQlnoxf6xttajbU=";
  };
  meta = {
    description = "Validate your CPAN META.json files";
    license = lib.licenses.artistic2;
  };
}
