{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Test-Cmd";
  version = "1.09";
  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NE/NEILB/Test-Cmd-1.09.tar.gz";
    hash = "sha256-zzMg7N3nkeC4lFogwfbyZdkPHj2rGPHiPLZ3x51yloQ=";
  };
  doCheck = false;
  meta = {
    description = "Perl module for portable testing of commands and scripts";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
