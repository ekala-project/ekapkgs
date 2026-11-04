{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Digest-MD2";
  version = "2.04";

  src = fetchurl {
    url = "mirror://cpan/authors/id/G/GA/GAAS/Digest-MD2-2.04.tar.gz";
    hash = "sha256-0Kq/SDTCCsQRvqQnxKMItZpfyqMnZ571KUwdaKtx7tM=";
  };

  meta = {
    description = "Perl interface to the MD2 Algorithm";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
