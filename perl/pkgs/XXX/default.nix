{
  buildPerlPackage,
  fetchurl,
  YAMLPP,
}:
buildPerlPackage {
  pname = "XXX";
  version = "0.38";
  src = fetchurl {
    url = "mirror://cpan/authors/id/I/IN/INGY/XXX-0.38.tar.gz";
    hash = "sha256-0QUQ6gD2Gav0erKZ8Ui9WzYM+gfcDtUYE4t87HJpLSo=";
  };
  propagatedBuildInputs = [ YAMLPP ];
  meta = {
    description = "See Your Data in the Nude";
  };
}
