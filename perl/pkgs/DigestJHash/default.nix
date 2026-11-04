{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Digest-JHash";
  version = "0.10";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Digest-JHash-0.10.tar.gz";
    hash = "sha256-x0bPCoYaAECQJjzVTXco0MdZWgz5DLv9hAmzlu47AGM=";
  };
  meta = {
    description = "Perl extension for 32 bit Jenkins Hashing Algorithm";
  };
}
