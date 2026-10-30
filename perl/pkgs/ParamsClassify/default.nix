{
  buildPerlModule,
  fetchurl,
  lib,
}:
buildPerlModule {

  pname = "Params-Classify";
  version = "0.015";
  src = fetchurl {
    url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/Params-Classify-0.015.tar.gz";
    hash = "sha256-OY7BXNiZ/Ni+89ueoXSL9jHxX2wyviA+R1tn31EKWRQ=";
  };
  meta = {
    description = "Argument type classification";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
