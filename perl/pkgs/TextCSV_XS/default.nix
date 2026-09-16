{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Text-CSV_XS";
  version = "1.62";
  src = fetchurl {
    url = "mirror://cpan/authors/id/H/HM/HMBRAND/Text-CSV_XS-1.62.tgz";
    hash = "sha256-FxBpPt2u/dVudNpCuqntZ25+rtKOvTA60jyYL+8rFBU=";
  };
}
