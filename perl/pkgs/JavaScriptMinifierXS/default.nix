{
  buildPerlPackage,
  fetchurl,
  lib,
  TestDiagINC,
}:
buildPerlPackage {
  pname = "JavaScript-Minifier-XS";
  version = "0.16";

  src = fetchurl {
    url = "mirror://cpan/authors/id/G/GT/GTERMARS/JavaScript-Minifier-XS-0.16.tar.gz";
    hash = "sha256-dQNOh2k568PdSM4uuvBgRLBu1XqzoYY/BT+VDphNmVQ=";
  };

  buildInputs = [ TestDiagINC ];

  meta = {
    description = "XS based JavaScript minifier";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
