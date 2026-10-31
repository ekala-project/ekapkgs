{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Carp-Assert";
  version = "0.22";
  src = fetchurl {
    url = "mirror://cpan/authors/id/Y/YV/YVES/Carp-Assert-0.22.tar.gz";
    hash = "sha256-gH6pfGvtdqwuSWnvun2uSP7+ufKHl/ESZxs6yKSTVfc=";
  };
  meta = {
    description = "Executable comments";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
