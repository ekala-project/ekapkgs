{
  buildPerlPackage,
  fetchurl,
  lib,
  bzip2,
}:
buildPerlPackage {
  pname = "Compress-Raw-Bzip2";
  version = "2.218";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PM/PMQS/Compress-Raw-Bzip2-2.218.tar.gz";
    hash = "sha256-iRU+ai69pSNJSTsHT6S3VJ/x+QU952E8GKXgXFtBX6g=";
  };

  env.BUILD_BZIP2 = false;

  env.BZIP2_LIB = "${bzip2.out}/lib";

  env.BZIP2_INCLUDE = "${bzip2.dev}/include";

  meta = {
    description = "Low-Level Interface to bzip2 compression library";
    homepage = "https://github.com/pmqs/Compress-Raw-Bzip2";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
