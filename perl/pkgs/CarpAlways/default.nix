{
  buildPerlPackage,
  fetchurl,
  TestBase,
}:
buildPerlPackage {
  pname = "Carp-Always";
  version = "0.16";
  src = fetchurl {
    url = "mirror://cpan/authors/id/F/FE/FERREIRA/Carp-Always-0.16.tar.gz";
    hash = "sha256-mKoRSSFxwBb7CCdYGrH6XtAbHpnGNXSJ3fOoJzFYZvE=";
  };
  buildInputs = [ TestBase ];
  meta = {
    description = "Warns and dies noisily with stack backtraces";
  };
}
