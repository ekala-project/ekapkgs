{
  buildPerlModule,
  fetchurl,
  lib,
  FileShareDir,
  Test2Suite,
}:
buildPerlModule {
  pname = "XS-Parse-Sublike";
  version = "0.37";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PE/PEVANS/XS-Parse-Sublike-0.37.tar.gz";
    hash = "sha256-c2UoyIjqe2phkQEeXVp4JOw4pWIFB95u9F5LxuHPDak=";
  };

  buildInputs = [ Test2Suite ];

  propagatedBuildInputs = [ FileShareDir ];

  meta = {
    description = "XS functions to assist in parsing sub-like syntax";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
