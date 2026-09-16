{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Config-Grammar";
  version = "1.13";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DS/DSCHWEI/Config-Grammar-1.13.tar.gz";
    hash = "sha256-qLOjosnIxDuS3EAb8nCdZRTxW0Z/1PcsSNNWM1dx1uM=";
  };
  meta = {
    description = "Grammar-based, user-friendly config parser";
  };
}
