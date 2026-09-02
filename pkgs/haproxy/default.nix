{
  stdenv,
  lib,
  fetchurl,
  zlib,
  libxcrypt,
  openssl,
  lua5_4,
  pcre2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "haproxy";
  version = "3.4.1";

  src = fetchurl {
    url = "https://www.haproxy.org/download/${lib.versions.majorMinor finalAttrs.version}/src/haproxy-${finalAttrs.version}.tar.gz";
    hash = "sha256-LmLEzk/XfTvHzxflhkMWY0VEVqB4t8hGW48BJbW8Ivg=";
  };

  buildInputs = [
    openssl
    zlib
    libxcrypt
    lua5_4
    pcre2
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "TARGET=linux-glibc"
  ];

  buildFlags = [
    "USE_ZLIB=yes"
    "USE_OPENSSL=yes"
    "SSL_INC=${lib.getDev openssl}/include"
    "SSL_LIB=${lib.getDev openssl}/lib"
    "USE_QUIC=yes"
    "USE_PCRE2=yes"
    "USE_PCRE2_JIT=yes"
    "USE_LUA=yes"
    "LUA_LIB_NAME=lua"
    "LUA_LIB=${lua5_4}/lib"
    "LUA_INC=${lua5_4}/include"
    "USE_GETADDRINFO=1"
    "USE_PROMEX=yes"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Reliable, high performance TCP/HTTP load balancer";
    homepage = "https://haproxy.org";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Only
    ];
    platforms = lib.platforms.linux;
    mainProgram = "haproxy";
  };
})
