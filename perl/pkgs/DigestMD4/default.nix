{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Digest-MD4";
  version = "1.9";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MIKEM/DigestMD4/Digest-MD4-1.9.tar.gz";
    hash = "sha256-ZlEQu6MkcPOY8xHNZGL9iXXXyDZ1/2dLwvbHtysMqqY=";
  };
  meta = {
    description = "Perl interface to the MD4 Algorithm";
  };
}
