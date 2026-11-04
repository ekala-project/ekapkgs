{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Log-Message";
  version = "0.08";

  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BI/BINGOS/Log-Message-0.08.tar.gz";
    hash = "sha256-vWl91iqvJtEY6fCggTQp3rHFRORQFVmHm2H8vf6Z/kY=";
  };

  meta = {
    description = "Powerful and flexible message logging mechanism";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
