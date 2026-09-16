{ buildPerlModule, fetchurl }:
buildPerlModule {
  pname = "Tie-IxHash";
  version = "1.23";
  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CH/CHORNY/Tie-IxHash-1.23.tar.gz";
    hash = "sha256-+rsLjJfmfJs0tswY7Wb2xeAcVbJX3PAHVV4LAn1Mr1Y=";
  };
  meta = {
    description = "Ordered associative arrays for Perl";
  };
}
