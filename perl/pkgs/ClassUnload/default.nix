{
  buildPerlPackage,
  fetchurl,
  ClassInspector,
  TestRequires,
}:
buildPerlPackage {
  pname = "Class-Unload";
  version = "0.11";

  src = fetchurl {
    url = "mirror://cpan/authors/id/I/IL/ILMARI/Class-Unload-0.11.tar.gz";
    hash = "sha256-UuKXR6fk0uGiicDh3oEHY08QyEJs18nTHsrIOD5KCl8=";
  };

  propagatedBuildInputs = [ ClassInspector ];

  buildInputs = [ TestRequires ];

  meta = {
    description = "Unload a class";
  };
}
