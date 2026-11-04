{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Module-Find";
  version = "0.16";
  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CR/CRENZ/Module-Find-0.16.tar.gz";
    hash = "sha256-S8qqN2kVAUco1PUzqYxbWdZlBRzTzbr8lg5aZv0TEJI=";
  };
  meta = {
    description = "Find and use installed modules in a (sub)category";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
