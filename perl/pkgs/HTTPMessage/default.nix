{
  buildPerlPackage,
  fetchurl,
  TestNeeds,
  TryTiny,
  Clone,
  EncodeLocale,
  HTTPDate,
  IOHTML,
  LWPMediaTypes,
  URI,
}:
buildPerlPackage {
  pname = "HTTP-Message";
  version = "6.45";
  src = fetchurl {
    url = "mirror://cpan/authors/id/O/OA/OALDERS/HTTP-Message-6.45.tar.gz";
    hash = "sha256-AcuEBmEqP3OIQtHpcxOuTYdIcNG41tZjMfFgAJQ9TL4=";
  };
  buildInputs = [
    TestNeeds
    TryTiny
  ];
  propagatedBuildInputs = [
    Clone
    EncodeLocale
    HTTPDate
    IOHTML
    LWPMediaTypes
    URI
  ];
  meta = {
    description = "HTTP style message (base class)";
  };
}
