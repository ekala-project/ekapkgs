{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Mail-POP3Client";
  version = "2.21";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SD/SDOWD/Mail-POP3Client-2.21.tar.gz";
    hash = "sha256-sW7yFJtuNXOHPx5ZDk1RNmxZlLi1MV3xaSXRe4niSQE=";
  };
  meta = {
    description = "Perl 5 module to talk to a POP3 (RFC1939) server";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
