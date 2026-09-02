{
  lib,
  stdenv,
  fetchurl,
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "renameutils";
  version = "0.12.0";

  src = fetchurl {
    url = "mirror://savannah/renameutils/renameutils-${finalAttrs.version}.tar.gz";
    sha256 = "18xlkr56jdyajjihcmfqlyyanzyiqqlzbhrm6695mkvw081g1lnb";
  };

  patches = [ ./install-exec.patch ];

  # Fix build with gcc 15
  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

  nativeBuildInputs = [ readline ];

  meta = {
    homepage = "https://www.nongnu.org/renameutils/";
    description = "Set of programs to make renaming of files faster";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
  };
})
