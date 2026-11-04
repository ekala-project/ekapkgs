{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Test-Portability-Files";
  version = "0.10";

  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AB/ABRAXXA/Test-Portability-Files-0.10.tar.gz";
    hash = "sha256-COS0MkktwbRLVdXbV5Uut2N5x/Q07o8WrKZNSR9AGhY=";
  };

  meta = {
    description = "Check file names portability";
  };
}
