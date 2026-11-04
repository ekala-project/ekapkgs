{
  buildPerlPackage,
  fetchurl,
  lib,
  gmp,
  MathBigInt,
}:
buildPerlPackage {
  pname = "Math-BigInt-GMP";
  version = "1.6013";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PJ/PJACKLAM/Math-BigInt-GMP-1.6013.tar.gz";
    hash = "sha256-yxqS4CJn1AUV+OA6TiEvZv0wfJdMu9MT4j3jL98Q9rU=";
  };

  buildInputs = [ gmp ];

  env.NIX_CFLAGS_COMPILE = "-I${gmp.dev}/include";

  env.NIX_CFLAGS_LINK = "-L${gmp.out}/lib -lgmp";

  propagatedBuildInputs = [ MathBigInt ];

  meta = {
    description = "Backend library for Math::BigInt etc. based on GMP";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
