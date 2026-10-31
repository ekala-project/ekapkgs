{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Number-Bytes-Human";
  version = "0.11";
  src = fetchurl {
    url = "mirror://cpan/authors/id/F/FE/FERREIRA/Number-Bytes-Human-0.11.tar.gz";
    hash = "sha256-X8ecSbC0DfeAR5xDaWOBND4ratH+UoWfYLxltm6+byw=";
  };
  meta = {
    description = "Convert byte count to human readable format";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
