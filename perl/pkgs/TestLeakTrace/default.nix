{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Test-LeakTrace";
  version = "0.17";
  src = fetchurl {
    url = "mirror://cpan/authors/id/L/LE/LEEJO/Test-LeakTrace-0.17.tar.gz";
    hash = "sha256-d31k0pOPXqWGMA7vl+8D6stD1MGFPJw7EJHrMxFGeXA=";
  };
  meta = {
    description = "Traces memory leaks";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
