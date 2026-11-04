{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Proc-Wait3";
  version = "0.05";

  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CT/CTILMES/Proc-Wait3-0.05.tar.gz";
    hash = "sha256-GpB/XbaTPcKTm7/v/hnurn7TnvG5eivJtyPy8l+ByvM=";
  };

  meta = {
    description = "Perl extension for wait3 system call";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
