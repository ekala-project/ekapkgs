{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "IO-Tee";
  version = "0.66";
  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NE/NEILB/IO-Tee-0.66.tar.gz";
    hash = "sha256-LZznIGUW+cMIY6NnqhwrmzVwLjabCrqhX5n7LMCFUuA=";
  };
  meta = {
    description = "Multiplex output to multiple output handles";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
