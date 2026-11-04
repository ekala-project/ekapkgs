{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "strictures";
  version = "2.000006";

  src = fetchurl {
    url = "mirror://cpan/authors/id/H/HA/HAARG/strictures-2.000006.tar.gz";
    hash = "sha256-CdV5dKbRsjgMgChw/tRxEI9RFw2oFFjidRhZ8nFPjVc=";
  };

  meta = {
    description = "Turn on strict and make most warnings fatal";
    homepage = "https://metacpan.org/pod/strictures";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
