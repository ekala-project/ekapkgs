{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Sys-SigAction";
  version = "0.23";

  src = fetchurl {
    url = "mirror://cpan/authors/id/L/LB/LBAXTER/Sys-SigAction-0.23.tar.gz";
    hash = "sha256-xO9sk0VTQDH8u+Ktw0f8cZTUevyUXnpE+sfpVjCV01M=";
  };

  meta = {
    description = "Perl extension for Consistent Signal Handling";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
