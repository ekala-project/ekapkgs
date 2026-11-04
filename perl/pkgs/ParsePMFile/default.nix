{
  buildPerlPackage,
  fetchurl,
  lib,
  ExtUtilsMakeMakerCPANfile,
}:
buildPerlPackage {
  pname = "Parse-PMFile";
  version = "0.44";

  src = fetchurl {
    url = "mirror://cpan/authors/id/I/IS/ISHIGAKI/Parse-PMFile-0.44.tar.gz";
    hash = "sha256-4I8PVkVbOsEtzNjHEWUGErfTzRUPim+K5rQ7LaR9+ZQ=";
  };

  buildInputs = [ ExtUtilsMakeMakerCPANfile ];

  meta = {
    description = "Parses .pm file as PAUSE does";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
