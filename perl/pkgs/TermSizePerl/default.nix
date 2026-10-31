{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Term-Size-Perl";
  version = "0.031";
  src = fetchurl {
    url = "mirror://cpan/authors/id/F/FE/FERREIRA/Term-Size-Perl-0.031.tar.gz";
    hash = "sha256-rppnRssbMF3cj42MpGh4VSucESNiiXHhOidRg4IvIJ4=";
  };
  meta = {
    description = "Perl extension for retrieving terminal size (Perl version)";
  };
}
