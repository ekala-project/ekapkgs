{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Number-Format";
  version = "1.76";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/Number-Format-1.76.tar.gz";
    hash = "sha256-DgBg6zY2NaiFcGxqJvX8qv6udZ97Ksrkndpw4ZXdRNY=";
  };
  meta = {
    description = "Perl extension for formatting numbers";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
