{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "UNIVERSAL-require";
  version = "0.19";
  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NE/NEILB/UNIVERSAL-require-0.19.tar.gz";
    hash = "sha256-1GfNJuBsjDsgP9O8B5aubIN6xeMQCTyCJn/134UPGgM=";
  };
  meta = {
    description = "Require() modules from a variable [deprecated]";
  };
}
