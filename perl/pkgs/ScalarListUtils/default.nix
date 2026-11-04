{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Scalar-List-Utils";
  version = "1.63";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PE/PEVANS/Scalar-List-Utils-1.63.tar.gz";
    hash = "sha256-yvvfIS9oJ9yaDdO1e27lDoYFhtcZgiijMmLVXFWesqk=";
  };

  meta = {
    description = "Common Scalar and List utility subroutines";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
