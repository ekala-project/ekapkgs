{
  buildPerlPackage,
  fetchurl,
  AuthenSASL,
}:
buildPerlPackage {
  pname = "XML-Stream";
  version = "1.24";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DAPATRICK/XML-Stream-1.24.tar.gz";
    hash = "sha256-vOXE9N3fPLbpSQO8vP7OOoZQUhMJwMxAGa7YMofZHVw=";
  };

  propagatedBuildInputs = [ AuthenSASL ];

  meta = {
    description = "Creates an XML Stream connection and parses return data";
  };
}
