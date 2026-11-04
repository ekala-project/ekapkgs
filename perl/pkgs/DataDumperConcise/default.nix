{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Data-Dumper-Concise";
  version = "2.023";

  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Data-Dumper-Concise-2.023.tar.gz";
    hash = "sha256-psIvETyvMRN1kN7xtwKKfnGO+s4yKCctBnLCXgNdWFM=";
  };

  meta = {
    description = "Less indentation and newlines plus sub deparsing";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
