{
  buildPerlPackage,
  fetchurl,
  lib,
  MathBase85,
  NetIPv4Addr,
}:
buildPerlPackage {
  pname = "Net-IPv6Addr";
  version = "1.02";
  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BK/BKB/Net-IPv6Addr-1.02.tar.gz";
    hash = "sha256-sjQBwSJv7o3+Yn9a4OkMVaxUcBDso5gRDcFjH0HJ7H0=";
  };
  propagatedBuildInputs = [
    MathBase85
    NetIPv4Addr
  ];
  meta = {
    description = "Check and manipulate IPv6 addresses";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
