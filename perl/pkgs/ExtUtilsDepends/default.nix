{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "ExtUtils-Depends";
  version = "0.8001";

  src = fetchurl {
    url = "mirror://cpan/authors/id/X/XA/XAOC/ExtUtils-Depends-0.8001.tar.gz";
    hash = "sha256-ZzxDh+eJbBohYJnB+7P6qndj1/X5WhpWpgoqKQbBMcU=";
  };

  meta = {
    description = "Easily build XS extensions that depend on XS extensions";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
      artistic1
      gpl1Plus
    ];
  };
}
