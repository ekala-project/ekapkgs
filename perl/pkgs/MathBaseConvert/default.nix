{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Math-Base-Convert";
  version = "0.11";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MIKER/Math-Base-Convert-0.11.tar.gz";
    hash = "sha256-jAlxNV8kyTt553rVSkVwCQoaWY/Lm4b1wX66QvOLQOA=";
  };

  meta = {
    description = "Very fast base to base conversion";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
