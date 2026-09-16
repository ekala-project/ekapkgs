{
  buildPerlModule,
  fetchurl,
  lib,
}:
buildPerlModule {
  pname = "List-UtilsBy";
  version = "0.12";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PE/PEVANS/List-UtilsBy-0.12.tar.gz";
    hash = "sha256-//EoH9Rp/pgrGlgES+z9lw8xO/86JuHHsrP0wKXtceA=";
  };
  meta = {
    description = "Higher-order list utility functions";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
