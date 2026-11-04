{
  buildPerlPackage,
  fetchurl,
  lib,
  CaptureTiny,
}:
buildPerlPackage {
  pname = "List-Compare";
  version = "0.55";

  src = fetchurl {
    url = "mirror://cpan/authors/id/J/JK/JKEENAN/List-Compare-0.55.tar.gz";
    hash = "sha256-zHGUeYNledUrArwyjtgKmPZ53wQ6mbVxCrLBkWaeuDc=";
  };

  buildInputs = [ CaptureTiny ];

  meta = {
    description = "Compare elements of two or more lists";
    homepage = "http://thenceforward.net/perl/modules/List-Compare";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
