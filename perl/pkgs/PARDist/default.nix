{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "PAR-Dist";
  version = "0.52";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RS/RSCHUPP/PAR-Dist-0.52.tar.gz";
    hash = "sha256-y+ljAJ6nnSRUqF/heU9CW33cHoa3F0nIhNsp1gHqj4g=";
  };
  meta = {
    description = "Create and manipulate PAR distributions";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
