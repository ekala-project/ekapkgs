{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Pod-Simple";
  version = "3.45";
  src = fetchurl {
    url = "mirror://cpan/authors/id/K/KH/KHW/Pod-Simple-3.45.tar.gz";
    hash = "sha256-hIO7lc0+QwfWbe8JKjd5+EOvdySCv9wCTj4A0MTbDPo=";
  };
  meta = {
    description = "Framework for parsing Pod";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
