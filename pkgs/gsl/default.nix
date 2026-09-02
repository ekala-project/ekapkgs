{
  fetchurl,
  fetchpatch,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gsl";
  version = "2.8";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnu/gsl/gsl-${finalAttrs.version}.tar.gz";
    hash = "sha256-apnu7RVjLGNUiVsd1ULtWoVcDxXZrRMmxv4rLJ5CMZA=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/macports/macports-ports/raw/90be777d2ce451d3c23783cb2be0efab9732e4d0/math/gsl/files/patch-fix-linking.diff";
      extraPrefix = "";
      hash = "sha256-lweYndIxcM5+4ckIUubkD9XbJbqkfdK+y9c3aRzmq0M=";
    })
  ];

  postInstall = ''
    moveToOutput bin/gsl-config "$dev"
  '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isx86_64 "-mno-fma";

  meta = {
    description = "GNU Scientific Library, a large numerical library";
    homepage = "https://www.gnu.org/software/gsl/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
  };
})
