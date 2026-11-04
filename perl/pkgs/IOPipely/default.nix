{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "IO-Pipely";
  version = "0.006";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RC/RCAPUTO/IO-Pipely-0.006.tar.gz";
    hash = "sha256-Dj/NhBoyfvtUn6AbIIPcNpXnLqDGMwPlbtUWG/gQQTs=";
  };

  meta = {
    description = "Portably create pipe() or pipe-like handles, one way or another";
    homepage = "https://search.cpan.org/dist/IO-Pipely";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
