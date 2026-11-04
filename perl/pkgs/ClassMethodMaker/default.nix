{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Class-MethodMaker";
  version = "2.24";

  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SC/SCHWIGON/class-methodmaker/Class-MethodMaker-2.24.tar.gz";
    hash = "sha256-Xu9YzLJ+vQG83lsUvMVTtTR6Bpnlw+khx3gMNSaJAyg=";
  };

  prePatch = "rm configure";

  meta = {
    description = "Module for creating generic methods";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
