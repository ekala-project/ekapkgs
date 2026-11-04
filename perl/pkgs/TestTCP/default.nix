{
  buildPerlPackage,
  fetchurl,
  lib,
  TestSharedFork,
}:
buildPerlPackage {
  pname = "Test-TCP";
  version = "2.22";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Test-TCP-2.22.tar.gz";
    hash = "sha256-PlPDwG1tCYCiv+uRVgK3FOaC7iEa6IwRdIzyzHFOe1c=";
  };

  buildInputs = [ TestSharedFork ];

  meta = {
    description = "Testing TCP program";
    homepage = "https://github.com/tokuhirom/Test-TCP";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
