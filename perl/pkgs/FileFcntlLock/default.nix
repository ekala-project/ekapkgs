{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "File-FcntlLock";
  version = "0.22";
  src = fetchurl {
    url = "mirror://cpan/authors/id/J/JT/JTT/File-FcntlLock-0.22.tar.gz";
    hash = "sha256-mpq7Lv/5Orc3QaEo0/cA5SUnNUbBXQTnxRxwSrCdvN8=";
  };
  meta = {
    description = "File locking with fcntl(2)";
  };
}
