{
  buildPerlPackage,
  fetchurl,
  ListSomeUtils,
  ListUtilsBy,
}:
buildPerlPackage {
  pname = "List-AllUtils";
  version = "0.19";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DR/DROLSKY/List-AllUtils-0.19.tar.gz";
    hash = "sha256-MKgUarIad4e4xW1YKc+afysVJ207P8oHM2rDjTAC/7w=";
  };
  propagatedBuildInputs = [
    ListSomeUtils
    ListUtilsBy
  ];
}
