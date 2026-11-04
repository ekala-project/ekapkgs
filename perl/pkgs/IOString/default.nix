{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "IO-String";
  version = "1.08";

  src = fetchurl {
    url = "mirror://cpan/authors/id/G/GA/GAAS/IO-String-1.08.tar.gz";
    hash = "sha256-Kj9K2EQtkHB4DljvQ3ItGdHuIagDv3yCBod6EEgt5aA=";
  };

  meta = {
    description = "Emulate file interface for in-core strings";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
