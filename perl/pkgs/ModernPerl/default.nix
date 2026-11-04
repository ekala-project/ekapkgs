{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Modern-Perl";
  version = "1.20230106";

  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CH/CHROMATIC/Modern-Perl-1.20230106.tar.gz";
    hash = "sha256-BFncq4DOgrY0Yf2B7pTgbpplFdmPP7wxmDjdHmAoUfc=";
  };

  meta = {
    description = "Enable all of the features of Modern Perl with one import";
  };
}
