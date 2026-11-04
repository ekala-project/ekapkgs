{
  buildPerlPackage,
  fetchurl,
  TextDiff,
}:
buildPerlPackage {
  pname = "Test-File-Contents";
  version = "0.242";

  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AR/ARISTOTLE/Test-File-Contents-0.242.tar.gz";
    hash = "sha256-qDisC29uEOiWE7UMphdzzbqbpHh7qC57tl2q9whKpQs=";
  };

  propagatedBuildInputs = [ TextDiff ];

  meta = {
    description = "Test routines for examining the contents of files";
  };
}
