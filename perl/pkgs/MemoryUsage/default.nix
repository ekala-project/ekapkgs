{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Memory-Usage";
  version = "0.201";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DO/DONEILL/Memory-Usage-0.201.tar.gz";
    hash = "sha256-jyr60h5Ap0joHIwPPkDKcYwU3bn7LYgL+9KK6RPOU0k=";
  };
  meta = {
    description = "Tools to determine actual memory usage";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
