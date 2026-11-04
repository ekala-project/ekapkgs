{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Digest-CRC";
  version = "0.24";

  src = fetchurl {
    url = "mirror://cpan/authors/id/O/OL/OLIMAUL/Digest-CRC-0.24.tar.gz";
    hash = "sha256-ugIqBbGtvsc3EsRvIz2Eif4Tobn8QKH8zu2bUvkN78E=";
  };

  meta = {
    description = "Module that calculates CRC sums of all sorts";
    license = lib.licenses.publicDomain;
  };
}
