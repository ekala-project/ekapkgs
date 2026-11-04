{
  buildPerlModule,
  fetchurl,
  lib,
  Test2Suite,
}:
buildPerlModule {
  pname = "Future";
  version = "0.50";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PE/PEVANS/Future-0.50.tar.gz";
    hash = "sha256-wDXj2eaaOvFEszrINN7p5lrTYPKlHbnxWNw0Ls3dX0Q=";
  };

  buildInputs = [ Test2Suite ];

  meta = {
    description = "Represent an operation awaiting completion";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
