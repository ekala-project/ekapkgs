{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "IO-Interactive";
  version = "1.025";
  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BD/BDFOY/IO-Interactive-1.025.tar.gz";
    hash = "sha256-yh7G+6t6AnXdLpz2e3yw4ARYY/MVMyEMfcVEYxtqqqc=";
  };
  meta = {
    description = "Utilities for interactive I/O";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
