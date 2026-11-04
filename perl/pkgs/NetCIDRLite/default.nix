{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Net-CIDR-Lite";
  version = "0.24";

  src = fetchurl {
    url = "mirror://cpan/authors/id/S/ST/STIGTSP/Net-CIDR-Lite-0.24.tar.gz";
    hash = "sha256-+rBqxO5gqYFhxmwQUPofJPa5lwmtD0sO3chOxxynrRc=";
  };

  meta = {
    description = "Perl extension for merging IPv4 or IPv6 CIDR addresses";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
