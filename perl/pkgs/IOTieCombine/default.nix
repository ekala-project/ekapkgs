{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "IO-TieCombine";
  version = "1.005";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/IO-TieCombine-1.005.tar.gz";
    hash = "sha256-QC1NuDALPScWMvSZXgreMp2JKAp+R/K634s4r25Vaa8=";
  };
  meta = {
    description = "Produce tied (and other) separate but combined variables";
    homepage = "https://github.com/rjbs/IO-TieCombine";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
