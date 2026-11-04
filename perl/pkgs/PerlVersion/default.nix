{
  buildPerlPackage,
  fetchurl,
  lib,
  FileSlurpTiny,
}:
buildPerlPackage {
  pname = "Perl-Version";
  version = "1.013";

  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BD/BDFOY/Perl-Version-1.013.tar.gz";
    hash = "sha256-GIdBTRyGidhkyEARQQHgQ+mdfdW5zKaTaaYOgh460Pc=";
  };

  propagatedBuildInputs = [ FileSlurpTiny ];

  meta = {
    description = "Parse and manipulate Perl version strings";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "perl-reversion";
  };
}
