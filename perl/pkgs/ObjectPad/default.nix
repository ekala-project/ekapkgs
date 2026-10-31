{
  buildPerlModule,
  fetchurl,
  lib,
  XSParseKeyword,
  XSParseSublike,
  Test2Suite,
  TestFatal,
  TestRefcount,
}:
buildPerlModule {
  pname = "Object-Pad";
  version = "0.821";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PE/PEVANS/Object-Pad-0.821.tar.gz";
    hash = "sha256-tdUF+PoWLg5r4q5YsPM0SUxPeRs6BA8va4kBTwSEUgw=";
  };
  buildInputs = [
    Test2Suite
    TestFatal
    TestRefcount
  ];
  propagatedBuildInputs = [
    XSParseKeyword
    XSParseSublike
  ];
  meta = {
    description = "Simple syntax for lexical field-based objects";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
