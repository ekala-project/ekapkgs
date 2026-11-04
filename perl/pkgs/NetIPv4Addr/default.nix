{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Net-IPv4Addr";
  version = "0.10";

  src = fetchurl {
    url = "mirror://cpan/authors/id/F/FR/FRAJULAC/Net-IPv4Addr-0.10.tar.gz";
    hash = "sha256-OEXeTzCxfIQrGSys6Iedu2IU3paSz6cPCq8JgUIqY/4=";
  };

  meta = {
    description = "Perl extension for manipulating IPv4 addresses";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
