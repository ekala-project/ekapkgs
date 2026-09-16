{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Class-Tiny";
  version = "1.008";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Class-Tiny-1.008.tar.gz";
    hash = "sha256-7gWKY5Evofy5pySY9WykIaIFbcf59LZ4N0RtZCGBVhU=";
  };
  meta = {
    description = "Minimalist class construction";
    license = lib.licenses.asl20;
  };
}
