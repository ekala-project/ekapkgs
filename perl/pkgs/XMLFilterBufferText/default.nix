{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "XML-Filter-BufferText";
  version = "1.01";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RB/RBERJON/XML-Filter-BufferText-1.01.tar.gz";
    hash = "sha256-j9ISbTvuxVTfhSkZ9HOeaJICy7pqF1Bum2bqFlhBp1w=";
  };
  doCheck = false;
  meta = {
    description = "Filter to put all characters() in one event";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
