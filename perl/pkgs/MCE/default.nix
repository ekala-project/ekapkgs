{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "MCE";
  version = "1.901";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MA/MARIOROY/MCE-1.901.tar.gz";
    hash = "sha256-3RRrHpmFPjPBzbtowgJK7nQGeseDlNUbgdH6so9Q0TU=";
  };
  meta = {
    description = "Many-Core Engine for Perl providing parallel processing capabilities";
    homepage = "https://github.com/marioroy/mce-perl";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
