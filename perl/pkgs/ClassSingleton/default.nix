{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Class-Singleton";
  version = "1.6";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHAY/Class-Singleton-1.6.tar.gz";
    hash = "sha256-J7oT8NlRKSkWa72MnvldkNYw/IDwyaG3RYiRBV6SgqQ=";
  };
  meta = {
    description = "Implementation of a Singleton class";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
