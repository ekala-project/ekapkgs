{
  buildPerlPackage,
  fetchurl,
  lib,
  MROCompat,
  SubExporter,
  TestFailWarnings,
}:
buildPerlPackage {
  pname = "Data-Section";
  version = "0.200008";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/Data-Section-0.200008.tar.gz";
    hash = "sha256-g6zHpV091+026deNNQrzE4xpz6F4pEdlgicS/0M7mQ4=";
  };

  propagatedBuildInputs = [
    MROCompat
    SubExporter
  ];

  buildInputs = [ TestFailWarnings ];

  meta = {
    description = "Read multiple hunks of data out of your DATA section";
    homepage = "https://github.com/rjbs/Data-Section";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
