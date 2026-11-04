{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Net-CIDR";
  version = "0.27";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MR/MRSAM/Net-CIDR-0.27.tar.gz";
    hash = "sha256-npUP70QiJk3I76sw27084r4SXmGz9cUBEdFVBtO1cOM=";
  };
  meta = {
    description = "Manipulate IPv4/IPv6 netblocks in CIDR notation";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
