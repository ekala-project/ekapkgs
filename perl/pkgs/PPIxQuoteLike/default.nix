{
  buildPerlModule,
  fetchurl,
  lib,
  PPI,
  Readonly,
}:
buildPerlModule {
  pname = "PPIx-QuoteLike";
  version = "0.023";

  src = fetchurl {
    url = "mirror://cpan/authors/id/W/WY/WYANT/PPIx-QuoteLike-0.023.tar.gz";
    hash = "sha256-NXajFJ0sU+B+lze3iSvlz7hKSZpu8d8JC3E7BUQjTSE=";
  };

  propagatedBuildInputs = [
    PPI
    Readonly
  ];

  meta = {
    description = "Parse Perl string literals and string-literal-like things";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
