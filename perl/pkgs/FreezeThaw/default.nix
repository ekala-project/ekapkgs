{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "FreezeThaw";
  version = "0.5001";

  src = fetchurl {
    url = "mirror://cpan/authors/id/I/IL/ILYAZ/modules/FreezeThaw-0.5001.tar.gz";
    hash = "sha256-PF4IMpEG+c7jq0RLgTMcWTX4MIShUdiFBeekZdpUD0E=";
  };

  meta = {
    description = "Converting Perl structures to strings and back";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
