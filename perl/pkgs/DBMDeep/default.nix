{
  buildPerlPackage,
  fetchurl,
  lib,
  TestDeep,
  TestException,
  TestPod,
  TestPodCoverage,
  TestWarn,
}:
buildPerlPackage {
  pname = "DBM-Deep";
  version = "2.0017";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DC/DCANTRELL/DBM-Deep-2.0017.tar.gz";
    hash = "sha256-1yNFIFdVO72UXWMhXr/gqnepLsbg+jOw2spXrhuKTSQ=";
  };

  buildInputs = [
    TestDeep
    TestException
    TestPod
    TestPodCoverage
    TestWarn
  ];

  meta = {
    description = "Pure perl multi-level hash/array DBM that supports transactions";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
