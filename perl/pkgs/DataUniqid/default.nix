{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Data-Uniqid";
  version = "0.12";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MW/MWX/Data-Uniqid-0.12.tar.gz";
    hash = "sha256-tpGbpJuf6Yv98+isyue5t/eNyeceu9C3/vekXZkyTMs=";
  };
}
