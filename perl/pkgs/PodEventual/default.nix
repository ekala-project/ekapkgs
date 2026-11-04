{
  buildPerlPackage,
  fetchurl,
  lib,
  MixinLinewise,
  TestDeep,
}:
buildPerlPackage {
  pname = "Pod-Eventual";
  version = "0.094003";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/Pod-Eventual-0.094003.tar.gz";
    hash = "sha256-fwYMw00RZWzgadsGHj1g7cDKvI+JpKLcfqrpXayFbS0=";
  };
  propagatedBuildInputs = [ MixinLinewise ];
  buildInputs = [ TestDeep ];
  preCheck = ''
    # Remove tests with hardcoded line numbers.
    rm t/non-pod.t
  '';
  meta = {
    description = "Read a POD document as a series of trivial events";
    homepage = "https://github.com/rjbs/Pod-Eventual";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
