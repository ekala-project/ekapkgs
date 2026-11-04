{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Class-ISA";
  version = "0.36";

  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SM/SMUELLER/Class-ISA-0.36.tar.gz";
    hash = "sha256-iBbzTpo46EmhDfdWAw3M+f4GGhlsEaw/qv1xE8kpuWQ=";
  };

  meta = {
    description = "Report the search path for a class's ISA tree";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
