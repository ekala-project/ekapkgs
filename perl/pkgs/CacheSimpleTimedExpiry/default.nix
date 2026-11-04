{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Cache-Simple-TimedExpiry";
  version = "0.27";

  src = fetchurl {
    url = "mirror://cpan/authors/id/J/JE/JESSE/Cache-Simple-TimedExpiry-0.27.tar.gz";
    hash = "sha256-Tni35N0jG1VxpIzQ7htjlT9eNHkMnQIOFZWnx9Crvkk=";
  };

  meta = {
    description = "Lightweight cache with timed expiration";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
