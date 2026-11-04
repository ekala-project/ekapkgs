{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Proc-Simple";
  version = "1.32";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MS/MSCHILLI/Proc-Simple-1.32.tar.gz";
    hash = "sha256-TI8KkksZrXihPac/4PswbTKnudEKMyxSMIf8g6IJqMQ=";
  };

  meta = {
    description = "Launch and control background processes";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
