{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {

  pname = "Sys-Hostname-Long";
  version = "1.5";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SC/SCOTT/Sys-Hostname-Long-1.5.tar.gz";
    hash = "sha256-6Rht83Bqh379YUnyxxHWz4fdbPcvark1uoEhsiWyZcs=";
  };
  doCheck = false; # no `hostname' in stdenv
  meta = {
    description = "Try every conceivable way to get full hostname";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
