{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "File-NFSLock";
  version = "1.29";

  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BB/BBB/File-NFSLock-1.29.tar.gz";
    hash = "sha256-YdQVmbSBFk7fm4vsq77y0j9iKpcn9sGDZekrV4LU+jc=";
  };

  meta = {
    description = "Perl module to do NFS (or not) locking";
    license = with lib.licenses; [
      artistic1
      gpl1Only
    ];
  };
}
