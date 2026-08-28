{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opencore-amr";
  version = "0.1.6";

  src = fetchurl {
    url = "mirror://sourceforge/opencore-amr/opencore-amr/opencore-amr-${finalAttrs.version}.tar.gz";
    hash = "sha256-SD60BhCI4rNLNY5HVAtdSVqWzUaONhBQ+uYVsYCdxKE=";
  };

  meta = {
    homepage = "https://sourceforge.net/projects/opencore-amr/";
    description = "Library of OpenCORE Framework implementation of Adaptive Multi Rate Narrowband and Wideband speech codec";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
})
