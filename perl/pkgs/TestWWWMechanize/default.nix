{
  buildPerlPackage,
  fetchurl,
  lib,
  CarpAssertMore,
  HTTPServerSimple,
  WWWMechanize,
  TestLongString,
}:
buildPerlPackage {
  pname = "Test-WWW-Mechanize";
  version = "1.60";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PE/PETDANCE/Test-WWW-Mechanize-1.60.tar.gz";
    hash = "sha256-I/1y5+0b553h0CotFfDfCTQV4Oq2/GFf9rtoh0Emhnc=";
  };
  buildInputs = [ TestLongString ];
  propagatedBuildInputs = [
    CarpAssertMore
    HTTPServerSimple
    WWWMechanize
  ];
  meta = {
    description = "Testing-specific WWW::Mechanize subclass";
    homepage = "https://github.com/libwww-perl/WWW-Mechanize";
    license = lib.licenses.artistic2;
  };
}
