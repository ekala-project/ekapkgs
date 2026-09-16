{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Encode-Locale";
  version = "1.05";
  src = fetchurl {
    url = "mirror://cpan/authors/id/G/GA/GAAS/Encode-Locale-1.05.tar.gz";
    hash = "sha256-F2+gJ3H1QqTvsdvCpMko6PQ5G/QHhHO9YEDY8RrbDsE=";
  };
  meta = {
    description = "Determine the locale encoding";
  };
}
