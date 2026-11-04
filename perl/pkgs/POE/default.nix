{
  buildPerlPackage,
  fetchurl,
  lib,
  IOPipely,
  IOTty,
  POETestLoops,
}:
buildPerlPackage {
  pname = "POE";
  version = "1.370";
  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BI/BINGOS/POE-1.370.tar.gz";
    hash = "sha256-V94rY1sV+joxqeVd1REiFJ5UFOEVjugiNQYmNO4YppM=";
  };
  propagatedBuildInputs = [
    IOPipely
    IOTty
    POETestLoops
  ];
  preCheck = ''
    rm -f run_network_tests
    export RELEASE_TESTING=1
  '';
  meta = {
    description = "Portable, event-loop agnostic eventy networking and multitasking";
    homepage = "http://poe.perl.org";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
