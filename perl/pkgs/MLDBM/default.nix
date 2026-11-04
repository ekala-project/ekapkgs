{
  buildPerlModule,
  fetchurl,
  lib,
}:
buildPerlModule {
  pname = "MLDBM";
  version = "2.05";

  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CH/CHORNY/MLDBM-2.05.tar.gz";
    hash = "sha256-WGiA7QwggBq79nNHR+E+AgPt7+zm68TyDdtQWfAqF6I=";
  };

  meta = {
    description = "Store multi-level Perl hash structure in single level tied hash";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
