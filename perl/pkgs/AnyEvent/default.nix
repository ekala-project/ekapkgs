{
  buildPerlPackage,
  fetchurl,
  lib,
  CanaryStability,
}:
buildPerlPackage {

  pname = "AnyEvent";
  version = "7.17";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/ML/MLEHMANN/AnyEvent-7.17.tar.gz";
    hash = "sha256-UL7qaJwJj+Sq64OAbEC5/n+UbVdprPmfhJ8JkJGkuYU=";
  };
  buildInputs = [ CanaryStability ];
  meta = {
    description = "DBI of event loop programming";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };

}
