{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmcrypt";
  version = "2.5.8";

  src = fetchurl {
    url = "mirror://sourceforge/mcrypt/Libmcrypt/${finalAttrs.version}/libmcrypt-${finalAttrs.version}.tar.gz";
    hash = "sha256-5OtsB0u6sWisR7lHwZX/jO+dUaIRzdGMqcnvNNJ6Nz4=";
  };

  patches = [
    (fetchpatch {
      url = "https://gitlab.alpinelinux.org/alpine/aports/-/raw/v20251224/community/libmcrypt/c23.patch";
      hash = "sha256-yTBCi5f0s8SiM5aq8X135E2Wwl7S2sO1tsVDthCdAMg=";
    })
  ];

  configureFlags = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-implicit-function-declaration"
    "-Wno-implicit-int"
  ];

  meta = {
    description = "Replacement for the old crypt() package and crypt(1) command, with extensions";
    mainProgram = "libmcrypt-config";
    homepage = "https://mcrypt.sourceforge.net";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.all;
  };
})
