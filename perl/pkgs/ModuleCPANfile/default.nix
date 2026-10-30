{
  buildPerlPackage,
  fetchurl,
  lib,
  Filepushd,
}:
buildPerlPackage {
  pname = "Module-CPANfile";
  version = "1.1004";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Module-CPANfile-1.1004.tar.gz";
    hash = "sha256-iO++LppkLc6qGGQw/t/PmZqvDgb2zO0opxS45WtRSSE=";
  };
  buildInputs = [ Filepushd ];
  meta = {
    description = "Parse cpanfile";
    homepage = "https://github.com/miyagawa/cpanfile";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
