{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Devel-Symdump";
  version = "2.18";
  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AN/ANDK/Devel-Symdump-2.18.tar.gz";
    hash = "sha256-gm+BoQf1WSolFnZu1DvrR+EMyD7cnqSAkLAqNgQHdsA=";
  };
  meta = {
    description = "Dump symbol names or the symbol table";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
