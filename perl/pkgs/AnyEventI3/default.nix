{
  buildPerlPackage,
  fetchurl,
  lib,
  AnyEvent,
  JSONXS,
}:
buildPerlPackage {
  pname = "AnyEvent-I3";
  version = "0.19";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MS/MSTPLBG/AnyEvent-I3-0.19.tar.gz";
    hash = "sha256-G807YNs9VWAUjeeRNT6K8RciZPWoXncZe5/8BB2sSDo=";
  };
  propagatedBuildInputs = [
    AnyEvent
    JSONXS
  ];
  meta = {
    description = "Communicate with the i3 window manager";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
