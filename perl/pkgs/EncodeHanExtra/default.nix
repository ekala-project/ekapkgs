{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Encode-HanExtra";
  version = "0.23";
  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AU/AUDREYT/Encode-HanExtra-0.23.tar.gz";
    hash = "sha256-H9SwbK2nCFgAOvFT+UyGOzuV8uPQO6GNBFGoHVHbRDo=";
  };
}
