{
  buildPerlPackage,
  fetchurl,
  lib,
  PodCoverage,
}:
buildPerlPackage {
  pname = "Test-Pod-Coverage";
  version = "1.10";
  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NE/NEILB/Test-Pod-Coverage-1.10.tar.gz";
    hash = "sha256-SMnMqffZnu50EXZEW0Ma3wnAKeGqV8RwPJ9G92AdQNQ=";
  };
  propagatedBuildInputs = [ PodCoverage ];
  meta = {
    description = "Check for pod coverage in your distribution";
    license = lib.licenses.artistic2;
  };
}
