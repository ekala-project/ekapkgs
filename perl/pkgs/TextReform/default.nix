{ buildPerlModule, fetchurl }:
buildPerlModule {
  pname = "Text-Reform";
  version = "1.20";
  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CH/CHORNY/Text-Reform-1.20.tar.gz";
    hash = "sha256-qHkt2MGqyXABAyM3s2o1a+luLXTE8DnvmjY7ZB20rmE=";
  };
  meta = {
    description = "Manual text wrapping and reformatting";
  };
}
