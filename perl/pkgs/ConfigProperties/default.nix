{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Config-Properties";
  version = "1.80";

  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SA/SALVA/Config-Properties-1.80.tar.gz";
    hash = "sha256-XQQ5W+fhTpcKA+qVL7dimuME2XwDH5DMHCm9Cmpi/EA=";
  };

  meta = {
    description = "Read and write property files";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
