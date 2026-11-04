{
  buildPerlPackage,
  fetchurl,
  lib,
  TestDeep,
}:
buildPerlPackage {
  pname = "Cache-FastMmap";
  version = "1.60";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RO/ROBM/Cache-FastMmap-1.60.tar.gz";
    hash = "sha256-my07Cu8JXSxZs1akSClQ0MOiLoTm5puXu5bcwe3GQv8=";
  };
  buildInputs = [ TestDeep ];
  meta = {
    description = "Uses an mmap'ed file to act as a shared memory interprocess cache";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
