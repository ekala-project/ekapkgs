{
  buildPerlPackage,
  fetchurl,
  lib,
  Curses,
}:
buildPerlPackage {
  pname = "Term-Animation";
  version = "2.6";
  src = fetchurl {
    url = "mirror://cpan/authors/id/K/KB/KBAUCOM/Term-Animation-2.6.tar.gz";
    hash = "sha256-fVw8LU+bZXqLHc5/Xiy74CraLpfHLzoDBL88mdCEsEU=";
  };
  propagatedBuildInputs = [ Curses ];
  meta = {
    description = "ASCII sprite animation framework";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
