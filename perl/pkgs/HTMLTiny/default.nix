{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "HTML-Tiny";
  version = "1.08";
  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AR/ARISTOTLE/HTML-Tiny-1.08.tar.gz";
    hash = "sha256-DwHfDJ/ICz2dooi6q/jApTdHRE964euWAOevxKPc/rU=";
  };
  meta = {
    description = "Lightweight, dependency free HTML/XML generation";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
