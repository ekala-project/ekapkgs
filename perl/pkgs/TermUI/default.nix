{
  buildPerlPackage,
  fetchurl,
  lib,
  LogMessageSimple,
}:
buildPerlPackage {
  pname = "Term-UI";
  version = "0.50";
  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BI/BINGOS/Term-UI-0.50.tar.gz";
    hash = "sha256-YL/dbUwVi4jTcBM/xlsgSFo2pFsS2QYAC4HHjKUkFj0=";
  };
  propagatedBuildInputs = [ LogMessageSimple ];
  meta = {
    description = "User interfaces via Term::ReadLine made easy";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
