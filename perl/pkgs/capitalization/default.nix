{
  buildPerlPackage,
  fetchurl,
  lib,
  DevelSymdump,
}:
buildPerlPackage {
  pname = "capitalization";
  version = "0.03";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/capitalization-0.03.tar.gz";
    hash = "sha256-8TUW1XKUH2ihwj8uDkn1vwmyL5B+uSkrcrr/5ie77jw=";
  };

  propagatedBuildInputs = [ DevelSymdump ];

  meta = {
    description = "No capitalization on method names";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
