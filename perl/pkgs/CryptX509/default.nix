{
  buildPerlPackage,
  fetchurl,
  lib,
  ConvertASN1,
}:
buildPerlPackage {
  pname = "Crypt-X509";
  version = "0.55";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MR/MRSCOTTY/Crypt-X509-0.55.tar.gz";
    hash = "sha256-FHlrEdFfdq10ROeKYZtw/92RMIaN0LANhYV5yTA4Icc=";
  };

  propagatedBuildInputs = [ ConvertASN1 ];

  meta = {
    description = "Parse a X.509 certificate";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
