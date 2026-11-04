{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Class-Autouse";
  version = "2.01";

  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AD/ADAMK/Class-Autouse-2.01.tar.gz";
    hash = "sha256-wFsyNsBXGdgZwg2w/ettCVR0fkPXpzgpTu1/vPNuzxs=";
  };

  meta = {
    description = "Run-time load a class the first time you call a method in it";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
