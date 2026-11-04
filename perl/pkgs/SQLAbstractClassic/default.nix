{
  buildPerlPackage,
  fetchurl,
  lib,
  TestDeep,
  TestException,
  TestWarn,
  SQLAbstract,
}:
buildPerlPackage {
  pname = "SQL-Abstract-Classic";
  version = "1.91";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RI/RIBASUSHI/SQL-Abstract-Classic-1.91.tar.gz";
    hash = "sha256-Tj0d/QlbISMmhYa7BrhpKepXE4jU6UGszL3NoeEI7yg=";
  };

  buildInputs = [
    TestDeep
    TestException
    TestWarn
  ];

  propagatedBuildInputs = [ SQLAbstract ];

  meta = {
    description = "Generate SQL from Perl data structures";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
