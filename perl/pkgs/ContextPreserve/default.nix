{
  buildPerlPackage,
  fetchurl,
  TestException,
}:
buildPerlPackage {
  pname = "Context-Preserve";
  version = "0.03";

  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Context-Preserve-0.03.tar.gz";
    hash = "sha256-CZFKTCx725nKtoDBg8v0kuyY1uI/vMSH/MSuEFZ9/R8=";
  };

  buildInputs = [ TestException ];

  meta = {
    description = "Run code after a subroutine call, preserving the context the subroutine would have seen if it were the last statement in the caller";
  };
}
