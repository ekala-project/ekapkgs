{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "String-Similarity";
  version = "1.04";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/ML/MLEHMANN/String-Similarity-1.04.tar.gz";
    hash = "sha256-H47aIpC7y3Ia7wzhsL/hOwEgHdPaphijN/LwLikcMkU=";
  };
  doCheck = true;
  meta = {
    description = "Calculate the similarity of two strings";
    license = lib.licenses.gpl2Only;
  };
}
