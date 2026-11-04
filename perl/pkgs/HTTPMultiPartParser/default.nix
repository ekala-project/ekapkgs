{
  buildPerlPackage,
  fetchurl,
  lib,
  TestDeep,
}:
buildPerlPackage {
  pname = "HTTP-MultiPartParser";
  version = "0.02";
  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CH/CHANSEN/HTTP-MultiPartParser-0.02.tar.gz";
    hash = "sha256-Xt3aFZ9U0W+GjgMkQKwrAk5VqsSJMYcbYmJ/GhbQCxI=";
  };
  buildInputs = [ TestDeep ];
  meta = {
    description = "HTTP MultiPart Parser";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
