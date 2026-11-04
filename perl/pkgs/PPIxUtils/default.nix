{
  buildPerlPackage,
  fetchurl,
  lib,
  BKeywords,
  PPI,
}:
buildPerlPackage {

  pname = "PPIx-Utils";
  version = "0.003";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DB/DBOOK/PPIx-Utils-0.003.tar.gz";
    hash = "sha256-KpvM/I6tA74BtnJI/o4VJSIED3mChvpO9EMrfy79uhE=";
  };
  propagatedBuildInputs = [
    BKeywords
    PPI
  ];
  meta = {
    homepage = "https://github.com/Grinnz/PPIx-Utils";
    description = "Utility functions for PPI";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };

}
