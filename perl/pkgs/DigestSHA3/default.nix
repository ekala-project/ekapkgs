{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Digest-SHA3";
  version = "1.05";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MS/MSHELOR/Digest-SHA3-1.05.tar.gz";
    hash = "sha256-rfG5B5sreBdV5XBId6FDCl8SmX6oIgX9KWbJzEZahSI=";
  };

  meta = {
    description = "Perl extension for SHA-3";
    homepage = "https://metacpan.org/release/Digest-SHA3";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
