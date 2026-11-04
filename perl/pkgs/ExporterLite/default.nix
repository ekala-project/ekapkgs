{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Exporter-Lite";
  version = "0.09";

  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NE/NEILB/Exporter-Lite-0.09.tar.gz";
    hash = "sha256-edixT9UBOSLGPoUPFb9RBZ8lAkBFNetmkO8jYSwqGY0=";
  };

  meta = {
    description = "Lightweight exporting of functions and variables";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
