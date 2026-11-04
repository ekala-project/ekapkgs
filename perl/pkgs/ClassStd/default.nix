{
  buildPerlModule,
  fetchurl,
  lib,
}:
buildPerlModule {
  pname = "Class-Std";
  version = "0.013";

  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CH/CHORNY/Class-Std-0.013.tar.gz";
    hash = "sha256-vNbYL2yK8P4Gn87X3RZaR5WwtukjUcfU5aGrmhT8NcY=";
  };

  meta = {
    description = "Support for creating standard 'inside-out' classes";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
