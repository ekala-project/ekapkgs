{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Devel-Leak";
  version = "0.03";
  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NI/NI-S/Devel-Leak-0.03.tar.gz";
    hash = "sha256-b0LDTxHitOPqLg5rlBaoimha3UR5EMr02R3SwXgXclI=";
  };
  meta = {
    description = "Utility for looking for perl objects that are not reclaimed";
    homepage = "https://metacpan.org/release/Devel-Leak";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
