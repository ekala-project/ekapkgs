{
  buildPerlPackage,
  fetchurl,
  lib,
  TextAutoformat,
}:
buildPerlPackage {
  pname = "Text-Quoted";
  version = "2.10";

  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BP/BPS/Text-Quoted-2.10.tar.gz";
    hash = "sha256-CBv5XskiCvJs7IkWHmG/c/n7y/7uHZrxUTnl17cI9EU=";
  };

  propagatedBuildInputs = [ TextAutoformat ];

  meta = {
    description = "Extract the structure of a quoted mail message";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
