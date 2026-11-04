{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Safe-Isa";
  version = "1.000010";

  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Safe-Isa-1.000010.tar.gz";
    hash = "sha256-h/QUiqD/HV5lJyMyLqt9r6OAHJZ9b5GskUejxGe4pmo=";
  };

  meta = {
    description = "Call isa, can, does and DOES safely on things that may not be objects";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
