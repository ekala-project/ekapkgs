{
  buildPerlPackage,
  fetchurl,
  lib,
  CaptureTiny,
  TestException,
  TestWarnings,
  ClassMethodMaker,
  TermReadKey,
}:
buildPerlPackage {
  pname = "Term-ProgressBar";
  version = "2.23";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MA/MANWAR/Term-ProgressBar-2.23.tar.gz";
    hash = "sha256-3vwD+59KwcnfE1nTEr/zwIZd3vvzq6ZM1CppqGIV1J0=";
  };
  buildInputs = [
    CaptureTiny
    TestException
    TestWarnings
  ];
  propagatedBuildInputs = [
    ClassMethodMaker
    TermReadKey
  ];
  meta = {
    description = "Provide a progress meter on a standard terminal";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
