{
  buildPerlPackage,
  fetchurl,
  lib,
  gmp,
}:
buildPerlPackage {
  pname = "Math-GMP";
  version = "2.25";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Math-GMP-2.25.tar.gz";
    hash = "sha256-OCtx5Udi9jnppCqbBpNBUZh7pX0Ru3DTXjvsiNUEUM4=";
  };
  buildInputs = [ gmp ];
  env.NIX_CFLAGS_COMPILE = "-I${gmp.dev}/include";
  env.NIX_CFLAGS_LINK = "-L${gmp.out}/lib -lgmp";
  meta = {
    description = "High speed arbitrary size integer math";
    license = lib.licenses.lgpl21Plus;
  };
}
