{
  buildPerlModule,
  fetchurl,
  lib,
}:
buildPerlModule {

  pname = "Path-Class";
  version = "0.37";
  src = fetchurl {
    url = "mirror://cpan/authors/id/K/KW/KWILLIAMS/Path-Class-0.37.tar.gz";
    hash = "sha256-ZUeBlIYCOG8ssuRHOnOfF9xpU9kqq8JJikyiVhvCSM4=";
  };
  meta = {
    description = "Cross-platform path specification manipulation";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
