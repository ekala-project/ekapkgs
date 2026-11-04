{
  buildPerlPackage,
  fetchurl,
  lib,
  TestDeep,
  LogDispatch,
}:
buildPerlPackage {
  pname = "Log-Dispatch-Array";
  version = "1.005";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/Log-Dispatch-Array-1.005.tar.gz";
    hash = "sha256-MRZAt6ln+N18m7QaInBzVlY21w30/MHUT+2KgiOzR8o=";
  };
  buildInputs = [ TestDeep ];
  propagatedBuildInputs = [ LogDispatch ];
  meta = {
    description = "Log events to an array (reference)";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
