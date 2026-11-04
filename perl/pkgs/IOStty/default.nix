{
  buildPerlModule,
  fetchurl,
  lib,
}:
buildPerlModule {
  pname = "IO-Stty";
  version = "0.04";

  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TO/TODDR/IO-Stty-0.04.tar.gz";
    hash = "sha256-XJUJ8ahpPYKH+gE97wv4eqZM2ScThGHvjetVUDxmUcI=";
  };

  buildPhase = "make";

  checkPhase = "make test";

  installPhase = "make install";

  meta = {
    description = "Change and print terminal line settings";
    homepage = "https://github.com/cpan-authors/IO-Stty";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
