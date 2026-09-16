{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Canary-Stability";
  version = "2013";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/ML/MLEHMANN/Canary-Stability-2013.tar.gz";
    hash = "sha256-pckcYs+V/Lho9g6rXIMpCPaQUiEBP+orzj/1cEbXtuo=";
  };
  meta = {
    description = "Canary to check perl compatibility for schmorp's modules";
    license = lib.licenses.gpl1Plus;
  };
}
