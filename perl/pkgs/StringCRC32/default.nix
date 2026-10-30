{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "String-CRC32";
  version = "2.100";
  src = fetchurl {
    url = "mirror://cpan/authors/id/L/LE/LEEJO/String-CRC32-2.100.tar.gz";
    hash = "sha256-lwYJOy0Gi2cV01tMWPUVWON5YAgyAhKfuwClfhmnRxM=";
  };
  meta = {
    description = "Perl interface for cyclic redundancy check generation";
    license = lib.licenses.publicDomain;
  };
}
