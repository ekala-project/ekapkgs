{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Math-Base85";
  version = "0.5";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PT/PTC/Math-Base85-0.5.tar.gz";
    hash = "sha256-CwX3+2UKh5ezktjqkPLnK/uNCFBcmi4LlV39RacqNOU=";
  };
  meta = {
    description = "Perl extension for base 85 numbers, as referenced by RFC 1924";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
