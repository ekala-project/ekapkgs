{
  buildPerlPackage,
  fetchurl,
  lib,
  HashOrdered,
}:
buildPerlPackage {
  pname = "User-Identity";
  version = "1.02";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MA/MARKOV/User-Identity-1.02.tar.gz";
    hash = "sha256-OySu5/UnjGXD8EEVsHyG5kaTTpnqQJJANj8wiZE+uJk=";
  };
  propagatedBuildInputs = [ HashOrdered ];
  meta = {
    description = "Collect information about a user";
    homepage = "http://perl.overmeer.net/CPAN";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
