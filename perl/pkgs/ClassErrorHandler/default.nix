{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Class-ErrorHandler";
  version = "0.04";

  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/Class-ErrorHandler-0.04.tar.gz";
    hash = "sha256-NC0tz8eXogvugXmxuWuFwK56W0iCc1lSPNjHTD5wRQI=";
  };

  meta = {
    description = "Base class for error handling";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
