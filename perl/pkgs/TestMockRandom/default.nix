{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Test-MockRandom";
  version = "1.01";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Test-MockRandom-1.01.tar.gz";
    hash = "sha256-JhSTDYT8XerDmvvB7obM05siFQfyfU7kk8om5ckhzOA=";
  };

  meta = {
    description = "Replaces random number generation with non-random number generation";
  };
}
