{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "IPC-Signal";
  version = "1.00";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RO/ROSCH/IPC-Signal-1.00.tar.gz";
    hash = "sha256-fCH5yMLQwPDw9G533nw9h53VYmaN3wUlh1w4zvIHb9A=";
  };
  meta = {
    description = "Utility functions dealing with signals";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
