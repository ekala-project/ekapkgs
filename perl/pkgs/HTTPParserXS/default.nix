{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "HTTP-Parser-XS";
  version = "0.17";

  src = fetchurl {
    url = "mirror://cpan/authors/id/K/KA/KAZUHO/HTTP-Parser-XS-0.17.tar.gz";
    hash = "sha256-eU5oM+MmsQ0kNp+c2/wWZxBe9lkej0HlYaPUGnAnqAk=";
  };

  meta = {
    description = "Fast, primitive HTTP request parser";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
