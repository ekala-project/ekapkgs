{
  buildPerlPackage,
  fetchurl,
  TestException,
  TestWarn,
  UNIVERSALcan,
  UNIVERSALisa,
}:
buildPerlPackage {
  pname = "Test-MockObject";
  version = "1.20200122";
  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CH/CHROMATIC/Test-MockObject-1.20200122.tar.gz";
    hash = "sha256-K3+A2of1pv4DYNnuUhBRBTAXRCw6Juhdto36yfgwdiM=";
  };
  buildInputs = [
    TestException
    TestWarn
  ];
  propagatedBuildInputs = [
    UNIVERSALcan
    UNIVERSALisa
  ];
  meta = {
    description = "Perl extension for emulating troublesome interfaces";
  };
}
