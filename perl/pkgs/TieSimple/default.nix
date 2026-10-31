{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Tie-Simple";
  version = "1.04";
  src = fetchurl {
    url = "mirror://cpan/authors/id/H/HA/HANENKAMP/Tie-Simple-1.04.tar.gz";
    hash = "sha256-KeniEzlRBGx48gXxs+jfYskOEU8OCPoGuBd2ag+AixI=";
  };
  meta = {
    description = "Variable ties made much easier: much, much, much easier";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
