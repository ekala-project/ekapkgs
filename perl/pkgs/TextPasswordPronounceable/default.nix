{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Text-Password-Pronounceable";
  version = "0.30";

  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TS/TSIBLEY/Text-Password-Pronounceable-0.30.tar.gz";
    hash = "sha256-wYalAlbgvt+vsX584VfnxS8ZUDu3nhjr8GJVkR9urRo=";
  };

  meta = {
    description = "Generate pronounceable passwords";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
