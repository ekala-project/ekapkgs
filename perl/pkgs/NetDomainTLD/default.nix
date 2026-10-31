{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Net-Domain-TLD";
  version = "1.75";
  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AL/ALEXP/Net-Domain-TLD-1.75.tar.gz";
    hash = "sha256-TDf4ERhNaKxBedSMEOoxki3V/KLBv/zc2VxaKjtAAu4=";
  };
  meta = {
    description = "Work with TLD names";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
