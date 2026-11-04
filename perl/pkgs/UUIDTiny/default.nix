{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "UUID-Tiny";
  version = "1.04";

  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CA/CAUGUSTIN/UUID-Tiny-1.04.tar.gz";
    hash = "sha256-bc2SYE1k6WzGwYgZSuFqnTpGVWIk93tvPR0TEraPmj0=";
  };

  meta = {
    description = "Pure Perl UUID Support With Functional Interface";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
