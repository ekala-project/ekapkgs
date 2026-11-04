{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Set-IntSpan";
  version = "1.19";

  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SW/SWMCD/Set-IntSpan-1.19.tar.gz";
    hash = "sha256-EbdUmxPsXYfMaV3Ux3fNApg91f6YZgEod/tTD0iz39A=";
  };

  meta = {
    description = "Manages sets of integers, newsrc style";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
