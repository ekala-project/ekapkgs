{
  buildPerlPackage,
  fetchurl,
  TestException,
  ClassErrorHandler,
  ConvertASN1,
  CryptDESEDE3,
  CryptX,
}:
buildPerlPackage {
  pname = "Convert-PEM";
  version = "0.13";
  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TI/TIMLEGGE/Convert-PEM-0.13.tar.gz";
    hash = "sha256-eZ+jLCcAgfTmKSsN31GAlScQqKS+Ey6Qe9oxdqe9HCM=";
  };
  buildInputs = [ TestException ];
  propagatedBuildInputs = [
    ClassErrorHandler
    ConvertASN1
    CryptDESEDE3
    CryptX
  ];
  meta = {
    description = "Read/write encrypted ASN.1 PEM files";
  };
}
