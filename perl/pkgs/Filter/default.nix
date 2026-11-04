{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Filter";
  version = "1.64";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RU/RURBAN/Filter-1.64.tar.gz";
    hash = "sha256-E+f7fh0yZZjjZgEDzxl0vun2kKxbQ7M58sAi8rX87yw=";
  };
  meta = {
    description = "Source Filters";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
