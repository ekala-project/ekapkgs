{
  buildPerlPackage,
  fetchurl,
  Readonly,
}:
buildPerlPackage {
  pname = "Readonly-XS";
  version = "1.05";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RO/ROODE/Readonly-XS-1.05.tar.gz";
    hash = "sha256-iuXE6FKZ5ci93RsZby7qOPAHCeDcDLYEVNyRFK4//w0=";
  };
  propagatedBuildInputs = [ Readonly ];
}
