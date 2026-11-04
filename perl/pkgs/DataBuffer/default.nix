{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Data-Buffer";
  version = "0.04";
  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BT/BTROTT/Data-Buffer-0.04.tar.gz";
    hash = "sha256-Kz0Jt7zzifwRYgeyg77iUONI1EycY0YL7mfvq03SG7Q=";
  };
  meta = {
    description = "Read/write buffer class";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
