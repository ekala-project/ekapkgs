{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Data-HexDump";
  version = "0.04";
  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NE/NEILB/Data-HexDump-0.04.tar.gz";
    hash = "sha256-vDb0BEOKw2rSuSlVOSJ9Nvmc0WI/HjR693xZTEDMvPg=";
  };
  meta = {
    description = "Hexadecial Dumper";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
