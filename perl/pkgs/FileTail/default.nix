{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "File-Tail";
  version = "1.3";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MG/MGRABNAR/File-Tail-1.3.tar.gz";
    hash = "sha256-JtCfgYNuQ+rkACjVKD/lYg/m/mJ4vz6462AMSOw0r8c=";
  };
  meta = {
    description = "Perl extension for reading from continuously updated files";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
