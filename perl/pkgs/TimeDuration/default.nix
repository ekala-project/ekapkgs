{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Time-Duration";
  version = "1.21";

  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NE/NEILB/Time-Duration-1.21.tar.gz";
    hash = "sha256-/jQOuodl+SY2lGdOXf8UgzRD4Zhl5f9Ce715t7X4qbg=";
  };

  meta = {
    description = "Rounded or exact English expression of durations";
    homepage = "https://github.com/neilbowers/Time-Duration";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
