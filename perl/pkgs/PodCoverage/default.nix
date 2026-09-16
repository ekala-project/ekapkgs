{
  buildPerlPackage,
  fetchurl,
  lib,
  DevelSymdump,
  PodParser,
}:
buildPerlPackage {
  pname = "Pod-Coverage";
  version = "0.23";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RC/RCLAMP/Pod-Coverage-0.23.tar.gz";
    hash = "sha256-MLegsMlC9Ep1UsDTTpsfLgugtnlVxh47FYnsNpB0sQc=";
  };
  propagatedBuildInputs = [
    DevelSymdump
    PodParser
  ];
  meta = {
    description = "Checks if the documentation of a module is comprehensive";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "pod_cover";
  };
}
