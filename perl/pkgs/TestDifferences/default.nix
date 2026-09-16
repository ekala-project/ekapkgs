{
  buildPerlPackage,
  fetchurl,
  CaptureTiny,
  TextDiff,
}:
buildPerlPackage {
  pname = "Test-Differences";
  version = "0.70";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DC/DCANTRELL/Test-Differences-0.70.tar.gz";
    hash = "sha256-vuG1GGqpuif+0r8bBnRSDQvQzQUdkTOH+QhsH5SlaFQ=";
  };
  propagatedBuildInputs = [
    CaptureTiny
    TextDiff
  ];
}
