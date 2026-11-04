{
  buildPerlPackage,
  fetchurl,
  lib,
  CaptureTiny,
  ClassLoad,
  TestKwalitee,
  TestPod,
}:
buildPerlPackage {
  pname = "App-CLI";
  version = "0.52";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PT/PTC/App-CLI-0.52.tar.gz";
    hash = "sha256-Ur1D9VWRPML/1kBfmVHSqr1Gr2PXAdm140amMycJ8M4=";
  };
  propagatedBuildInputs = [
    CaptureTiny
    ClassLoad
  ];
  buildInputs = [
    TestKwalitee
    TestPod
  ];
  meta = {
    description = "Dispatcher module for command line interface programs";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
