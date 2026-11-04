{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Crypt-SmbHash";
  version = "0.12";

  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BJ/BJKUIT/Crypt-SmbHash-0.12.tar.gz";
    hash = "sha256-aMSsfqv6lX3PiUwsI7zsCW+H6M8G3t/Lv3AuVTHbsTc=";
  };

  meta = {
    description = "Perl-only implementation of lanman and nt md4 hash functions, for use in Samba style smbpasswd entries";
  };
}
