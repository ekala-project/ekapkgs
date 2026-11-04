{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Test-MockTime";
  version = "0.17";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DD/DDICK/Test-MockTime-0.17.tar.gz";
    hash = "sha256-M2PhGLJgbx1qvJVvIrDQkQl3K3CGFV+1ycf5gzUGAvk=";
  };

  meta = {
    description = "Replaces actual time with simulated time";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
