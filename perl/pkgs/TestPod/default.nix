{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Test-Pod";
  version = "1.52";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Test-Pod-1.52.tar.gz";
    hash = "sha256-YKjbzGAWi/HapcwjUCNt+TQ+mHj0q5gwlwpd3m/o5fw=";
  };
  meta = {
    description = "Check for POD errors in files";
  };
}
