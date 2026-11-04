{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Text-German";
  version = "0.06";

  src = fetchurl {
    url = "mirror://cpan/authors/id/U/UL/ULPFR/Text-German-0.06.tar.gz";
    hash = "sha256-ki1PGQEtl3OxH0pvZCEF6fkT9YZvRGG2BZymdNW7B90=";
  };

  meta = {
    description = "German grundform reduction";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
