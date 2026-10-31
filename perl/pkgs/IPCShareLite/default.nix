{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "IPC-ShareLite";
  version = "0.17";
  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AN/ANDYA/IPC-ShareLite-0.17.tar.gz";
    hash = "sha256-FNQGuR2pbWUh0NGoLSKjBidHZSJrhrClbn/93Plq578=";
  };
  meta = {
    description = "Lightweight interface to shared memory";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
