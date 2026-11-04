{
  buildPerlPackage,
  fetchurl,
  lib,
  SubExporter,
}:
buildPerlPackage {
  pname = "String-Truncate";
  version = "1.100603";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/String-Truncate-1.100603.tar.gz";
    hash = "sha256-q0VgLM4t2VFe37sublzeGc3VSY1hojr9jEbB8R+O7GI=";
  };
  propagatedBuildInputs = [ SubExporter ];
  meta = {
    description = "Module for when strings are too long to be displayed in...";
    homepage = "https://github.com/rjbs/String-Truncate";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
