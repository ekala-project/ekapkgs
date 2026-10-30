{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Test-LongString";
  version = "0.17";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RG/RGARCIA/Test-LongString-0.17.tar.gz";
    hash = "sha256-q8Q0nq8E0b7B5GQWajAYWR6oRtjzxcnIr0rEkF0+l08=";
  };
  meta = {
    description = "Tests strings for equality, with more helpful failures";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
