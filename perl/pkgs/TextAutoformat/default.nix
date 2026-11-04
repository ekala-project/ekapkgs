{
  buildPerlPackage,
  fetchurl,
  lib,
  TextReform,
}:
buildPerlPackage {
  pname = "Text-Autoformat";
  version = "1.75";

  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NE/NEILB/Text-Autoformat-1.75.tar.gz";
    hash = "sha256-ndT0zj2uxLTb9bWdrEVoqJRq7RLCi05ZiMjoxgLGt3E=";
  };

  propagatedBuildInputs = [ TextReform ];

  meta = {
    description = "Automatic text wrapping and reformatting";
    homepage = "https://github.com/neilb/Text-Autoformat";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
