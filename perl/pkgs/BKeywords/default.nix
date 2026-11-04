{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "B-Keywords";
  version = "1.28";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RU/RURBAN/B-Keywords-1.28.tar.gz";
    hash = "sha256-nn62dpWSlIfGGq8trouvndoa2HYCu1oJTxB0SxJ2Xj4=";
  };

  meta = {
    description = "Lists of reserved barewords and symbol names";
    license = with lib.licenses; [
      artistic1
      gpl2Only
    ];
  };
}
