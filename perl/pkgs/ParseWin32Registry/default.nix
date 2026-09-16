{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "ParseWin32Registry";
  version = "1.1";
  src = fetchurl {
    url = "mirror://cpan/authors/id/J/JM/JMACFARLA/Parse-Win32Registry-1.1.tar.gz";
    hash = "sha256-wWOyAr5q17WPSEZJT/crjJqXloPKmU5DgOmsZWTcBbo=";
  };
  meta = {
    description = "Module for parsing Windows Registry files";
    license = with lib.licenses; [
      artistic1
      gpl1Only
    ];
  };
}
