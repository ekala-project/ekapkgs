{
  buildPerlPackage,
  fetchurl,
  lib,
  IOStringy,
}:
buildPerlPackage {
  pname = "Test-Strict";
  version = "0.54";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MA/MANWAR/Test-Strict-0.54.tar.gz";
    hash = "sha256-9oB1F4I6kKlrQN7q7ZqggAgt7UtQpRIE9b4efOd0yFw=";
  };

  buildInputs = [ IOStringy ];

  meta = {
    description = "Check syntax, presence of use strict; and test coverage";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
