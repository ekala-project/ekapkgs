{
  buildPerlPackage,
  fetchurl,
  lib,
  commonsense,
}:
buildPerlPackage {
  pname = "Types-Serialiser";
  version = "1.01";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/ML/MLEHMANN/Types-Serialiser-1.01.tar.gz";
    hash = "sha256-+McXOwkU0OPZVyggd7Nm8MjHAlZxXq7zKY/zK5I4ioA=";
  };
  propagatedBuildInputs = [ commonsense ];
  meta = {
    description = "Simple data types for common serialisation formats";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
