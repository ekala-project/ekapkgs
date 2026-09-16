{
  buildPerlPackage,
  fetchurl,
  lib,
  TieCycle,
}:
buildPerlPackage {
  pname = "Business-ISMN";
  version = "1.203";
  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BD/BDFOY/Business-ISMN-1.203.tar.gz";
    hash = "sha256-T1Ou2rLmh9Th9yhW6vwiFZOQYhEj2q955FBqiX4pPog=";
  };
  propagatedBuildInputs = [ TieCycle ];
  meta = {
    description = "Work with International Standard Music Numbers";
    license = lib.licenses.artistic2;
  };
}
