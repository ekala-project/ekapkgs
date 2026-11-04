{
  buildPerlPackage,
  fetchurl,
  lib,
  RegexpCommon,
}:
buildPerlPackage {
  pname = "Regexp-Common-net-CIDR";
  version = "0.03";

  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BP/BPS/Regexp-Common-net-CIDR-0.03.tar.gz";
    hash = "sha256-OWBqV6qyDU9EaDAPLsP6KrVX/MnLeIDsfG4H2AFi2jM=";
  };

  propagatedBuildInputs = [ RegexpCommon ];

  meta = {
    description = "Provide patterns for CIDR blocks";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
