{
  buildPerlModule,
  fetchurl,
  lib,
  ClassLoad,
}:
buildPerlModule {
  pname = "Test-Mock-Guard";
  version = "0.10";
  src = fetchurl {
    url = "mirror://cpan/authors/id/X/XA/XAICRON/Test-Mock-Guard-0.10.tar.gz";
    hash = "sha256-fyKKY/jWzrkqp4QIChPoUHMSGyg17KBteU+XCZUNvT0=";
  };
  propagatedBuildInputs = [ ClassLoad ];
  meta = {
    description = "Simple mock test library using RAII";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
