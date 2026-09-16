{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Data-Dump";
  version = "1.25";
  src = fetchurl {
    url = "mirror://cpan/authors/id/G/GA/GARU/Data-Dump-1.25.tar.gz";
    hash = "sha256-pKpuDdvznVrUm93+D4nZ2oZOO8APYnEl0bxYBHL1P70=";
  };
}
