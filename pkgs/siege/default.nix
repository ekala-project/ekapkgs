{
  lib,
  stdenv,
  fetchurl,
  openssl,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "siege";
  version = "4.1.7";

  src = fetchurl {
    url = "https://download.joedog.org/siege/siege-${finalAttrs.version}.tar.gz";
    hash = "sha256-7BQM7dFZl5OD1g2+h6AVHCwSraeHkQlaj6hK5jW5MCY=";
  };

  env =
    lib.optionalAttrs stdenv.hostPlatform.isLinux {
      NIX_LDFLAGS = toString [ "-lgcc_s" ];
      NIX_CFLAGS_COMPILE = "-std=gnu17";
    }
    // lib.optionalAttrs stdenv.cc.isClang {
      CFLAGS = "-Wno-int-conversion";
    };

  buildInputs = [
    openssl
    zlib
  ];

  prePatch = ''
    sed -i -e 's/u_int32_t/uint32_t/g' -e '1i#include <stdint.h>' src/hash.c
  '';

  configureFlags = [
    "--with-ssl=${openssl.dev}"
    "--with-zlib=${zlib.dev}"
  ];

  meta = {
    description = "HTTP load tester";
    homepage = "https://www.joedog.org/siege-home/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
