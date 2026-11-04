{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "POE-Test-Loops";
  version = "1.360";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RC/RCAPUTO/POE-Test-Loops-1.360.tar.gz";
    hash = "sha256-vtDJb+kcmP035utZqASqrJzEqekoRQt21L9VJ6nmpHs=";
  };
  meta = {
    description = "Reusable tests for POE::Loop authors";
    homepage = "https://search.cpan.org/dist/POE-Test-Loops";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "poe-gen-tests";
  };
}
