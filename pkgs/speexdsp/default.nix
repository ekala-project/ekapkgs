{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "speexdsp";
  version = "1.2.1";

  src = fetchurl {
    url = "https://downloads.xiph.org/releases/speex/${pname}-${version}.tar.gz";
    sha256 = "sha256-jHdzQ+SmOZVpxyq8OKlbJNtWiCyD29tsZCSl9K61TT0=";
  };

  patches = [ ./build-fix.patch ];
  postPatch = "sed '3i#include <stdint.h>' -i ./include/speex/speexdsp_config_types.h.in";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  configureFlags = lib.optional stdenv.hostPlatform.isAarch64 "--disable-neon";

  meta = {
    homepage = "https://www.speex.org/";
    description = "DSP library for Speex audio compression";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
}
