{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {

  pname = "File-Slurp-Tiny";
  version = "0.004";
  src = fetchurl {
    url = "mirror://cpan/authors/id/L/LE/LEONT/File-Slurp-Tiny-0.004.tar.gz";
    hash = "sha256-RSmVvuq/DpI+Zf3GJ6cl27EsnhDADYAYwW0QumJ1fx4=";
  };
  meta = {
    description = "Simple, sane and efficient file slurper [DISCOURAGED]";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
