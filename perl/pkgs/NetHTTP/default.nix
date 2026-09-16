{
  buildPerlPackage,
  fetchurl,
  URI,
}:
buildPerlPackage {
  pname = "Net-HTTP";
  version = "6.23";
  src = fetchurl {
    url = "mirror://cpan/authors/id/O/OA/OALDERS/Net-HTTP-6.23.tar.gz";
    hash = "sha256-DWXAndbIWJsq4RGBdNPBphcDtuz8FKNEKox0r2XgyU4=";
  };
  propagatedBuildInputs = [ URI ];
  doCheck = false;
  meta = {
    description = "Low-level HTTP connection (client)";
  };
}
