{
  buildPerlPackage,
  fetchurl,
  lib,
  IOStringy,
}:
buildPerlPackage {
  pname = "Image-Info";
  version = "1.44";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SR/SREZIC/Image-Info-1.44.tar.gz";
    hash = "sha256-y3/GXdHv/gHrR8HHmlLdFlT0KOOpfbHvI7EmzgFjbw0=";
  };
  propagatedBuildInputs = [ IOStringy ];
  meta = {
    description = "Extract meta information from image files";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
