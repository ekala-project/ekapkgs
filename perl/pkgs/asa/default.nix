{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "asa";
  version = "1.04";

  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/asa-1.04.tar.gz";
    hash = "sha256-5YM7dOczuu4Z0e9eBLEmPBz/nBdGmVrXL8QJGPRAZ14=";
  };

  meta = {
    description = "Lets your class/object say it works like something else";
    homepage = "https://github.com/karenetheridge/asa";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
