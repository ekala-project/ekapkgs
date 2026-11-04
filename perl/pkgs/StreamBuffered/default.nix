{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Stream-Buffered";
  version = "0.03";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DO/DOY/Stream-Buffered-0.03.tar.gz";
    hash = "sha256-my1DkLXeawz0VY5K0EMXpzxeE90ZrykUnE5Hw3+yQjs=";
  };

  meta = {
    description = "Temporary buffer for a stream";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
