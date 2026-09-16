{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Crypt-Rijndael";
  version = "1.16";
  src = fetchurl {
    url = "mirror://cpan/authors/id/L/LE/LEONT/Crypt-Rijndael-1.16.tar.gz";
    hash = "sha256-ZUAIXjgEuCpvB1LBEiz3jK3SIZkBNt1v1MCX0FbITUA=";
  };
  meta = {
    description = "Crypt::CBC compliant Rijndael encryption module";
  };
}
