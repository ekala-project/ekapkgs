{
  buildPerlPackage,
  fetchurl,
  lib,
  TestException,
  TestMemoryCycle,
  FontTTF,
}:
buildPerlPackage {
  pname = "PDF-API2";
  version = "2.045";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SS/SSIMMS/PDF-API2-2.045.tar.gz";
    hash = "sha256-tr204NDNZSYQP91YwXHgVgw2uEO3/jyk3cm7HkyDJAY=";
  };
  buildInputs = [
    TestException
    TestMemoryCycle
  ];
  propagatedBuildInputs = [ FontTTF ];
  meta = {
    description = "Create, modify, and examine PDF files";
    license = lib.licenses.lgpl21Plus;
  };
}
