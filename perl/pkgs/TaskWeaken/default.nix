{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Task-Weaken";
  version = "1.06";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Task-Weaken-1.06.tar.gz";
    hash = "sha256-I4P+252672RkaOqCSvv3yAEHZyDPug3yp6B0cm3NZr4=";
  };
  meta = {
    description = "Ensure that a platform has weaken support";
  };
}
