{
  buildPerlPackage,
  fetchurl,
  lib,
  TestWarn,
  Moo,
}:
buildPerlPackage {
  pname = "Parallel-ForkManager";
  version = "2.02";
  src = fetchurl {
    url = "mirror://cpan/authors/id/Y/YA/YANICK/Parallel-ForkManager-2.02.tar.gz";
    hash = "sha256-wbKXCou2ZsPefKrEqPTbzAQ6uBm7wzdpLse/J62uRAQ=";
  };
  buildInputs = [ TestWarn ];
  propagatedBuildInputs = [ Moo ];
  meta = {
    description = "Simple parallel processing fork manager";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
