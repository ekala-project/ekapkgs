{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Time-ParseDate";
  version = "2015.103";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MU/MUIR/modules/Time-ParseDate-2015.103.tar.gz";
    hash = "sha256-LBoGI1v4EYE8qsnqqdqnGvdYZnzfewgstZhjIg/K7tE=";
  };
  doCheck = false;
  meta = {
    description = "Parse and format time values";
  };
}
