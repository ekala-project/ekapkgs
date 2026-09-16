{
  buildPerlPackage,
  fetchurl,
  TestRequires,
  IPCRun3,
  TextParsewords,
}:
buildPerlPackage {
  pname = "Module-ScanDeps";
  version = "1.37";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RS/RSCHUPP/Module-ScanDeps-1.37.tar.gz";
    hash = "sha256-H14RnK3hRmw5xx5bw1qNT05nJjXbA9eaWg3PCMTitaM=";
  };
  buildInputs = [
    TestRequires
    IPCRun3
  ];
  propagatedBuildInputs = [ TextParsewords ];
  meta = {
    description = "Recursively scan Perl code for dependencies";
  };
}
