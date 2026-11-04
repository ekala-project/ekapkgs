{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Filesys-Df";
  version = "0.92";

  src = fetchurl {
    url = "mirror://cpan/authors/id/I/IG/IGUTHRIE/Filesys-Df-0.92.tar.gz";
    hash = "sha256-/onLtCfg4F8c2Xwt1tOGasayG8eoVzTt4Vm9w1R5VSo=";
  };

  meta = {
    description = "Perl extension for filesystem disk space information";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
