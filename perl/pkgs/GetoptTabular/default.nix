{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Getopt-Tabular";
  version = "0.3";

  src = fetchurl {
    url = "mirror://cpan/authors/id/G/GW/GWARD/Getopt-Tabular-0.3.tar.gz";
    hash = "sha256-m98GdjO1kTEngg9OgDXtxT0INy+qzla6a/oAyWiiU3c=";
  };

  meta = {
    description = "Table-driven argument parsing for Perl 5";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
