{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Module-Versions-Report";
  version = "1.06";
  src = fetchurl {
    url = "mirror://cpan/authors/id/J/JE/JESSE/Module-Versions-Report-1.06.tar.gz";
    hash = "sha256-oyYdDYSxdnjYxP1V6w+JL1FE2BylPqmjjXXRoArZeWo=";
  };
  meta = {
    description = "Report versions of all modules in memory";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
