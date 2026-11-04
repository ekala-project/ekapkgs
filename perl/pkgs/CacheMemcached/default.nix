{
  buildPerlPackage,
  fetchurl,
  lib,
  StringCRC32,
}:
buildPerlPackage {
  pname = "Cache-Memcached";
  version = "1.30";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DO/DORMANDO/Cache-Memcached-1.30.tar.gz";
    hash = "sha256-MbPFHsDqrwMALizI49fVy+YZGc/a2mHACOuYU6ysQqk=";
  };

  propagatedBuildInputs = [ StringCRC32 ];

  meta = {
    description = "Client library for memcached (memory cache daemon)";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
