{
  buildPerlModule,
  fetchurl,
  lib,
}:
buildPerlModule {
  pname = "Encode-Detect";
  version = "1.01";

  src = fetchurl {
    url = "mirror://cpan/authors/id/J/JG/JGMYERS/Encode-Detect-1.01.tar.gz";
    hash = "sha256-g02JOqfbbOPxWK+9DkMtbtFaJ24JQNsKdL4T/ZxLu/E=";
  };

  meta = {
    description = "Encode::Encoding subclass that detects the encoding of data";
    license = with lib.licenses; [
      mpl11
      gpl2Plus
      lgpl2Plus
    ];
  };
}
