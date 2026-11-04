{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Symbol-Global-Name";
  version = "0.05";
  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AL/ALEXMV/Symbol-Global-Name-0.05.tar.gz";
    hash = "sha256-D3Yj6dckdgqmQEAiLaHYLxGIWGeRMpJhzGDa0dYNapI=";
  };
  meta = {
    description = "Finds name and type of a global variable";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
