{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Tie-Cycle";
  version = "1.227";
  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BD/BDFOY/Tie-Cycle-1.227.tar.gz";
    hash = "sha256-eDgzV5HnGjszuKGd4wUpSeGJCkgj3vY5eCPJkiL6Hdg=";
  };
  meta = {
    description = "Cycle through a list of values via a scalar";
    license = lib.licenses.artistic2;
  };
}
