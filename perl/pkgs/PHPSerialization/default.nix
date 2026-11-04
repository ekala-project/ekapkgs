{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "PHP-Serialization";
  version = "0.34";

  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BO/BOBTFISH/PHP-Serialization-0.34.tar.gz";
    hash = "sha256-uRLUJumuulSRpeUC58XAOcXapXVCism9yCr/857G8Ho=";
  };

  meta = {
    description = "Simple flexible means of converting the output of PHP's serialize() into the equivalent Perl memory structure, and vice versa";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
