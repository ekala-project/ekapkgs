{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Devel-Size";
  version = "0.85";

  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NW/NWCLARK/Devel-Size-0.85.tar.gz";
    hash = "sha256-KS+YsT7dGqSlROOlzx2fLXAZ91xzZNLo+oo16lRR5z4=";
  };

  meta = {
    description = "Perl extension for finding the memory usage of Perl variables";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
