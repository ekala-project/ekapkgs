{
  buildPerlPackage,
  fetchurl,
  lib,
  PodCoverage,
  PodEventual,
}:
buildPerlPackage {
  pname = "Pod-Coverage-TrustPod";
  version = "0.100006";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/Pod-Coverage-TrustPod-0.100006.tar.gz";
    hash = "sha256-NYrcJQTwOetpCYqpm93mrp3JNTZKjhRPZAXoKTs6fKM=";
  };

  propagatedBuildInputs = [
    PodCoverage
    PodEventual
  ];

  meta = {
    description = "Allow a module's pod to contain Pod::Coverage hints";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
