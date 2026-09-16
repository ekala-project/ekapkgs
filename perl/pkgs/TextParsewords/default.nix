{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Text-ParseWords";
  version = "3.31";
  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NE/NEILB/Text-ParseWords-3.31.tar.gz";
    hash = "sha256-KuVVughNdbK4/u640aAJESdoFa2oa8yxRSI2lk1aL8c=";
  };
  meta = {
    description = "Parse text into an array of tokens or array of arrays";
  };
}
