{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  openssl,
  curl,
  libxml2,
  pcre2,
  libevent,
  zlib,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zabbix-agent";
  version = "7.0.4";

  src = fetchurl {
    url = "https://cdn.zabbix.com/zabbix/sources/stable/7.0/zabbix-${finalAttrs.version}.tar.gz";
    hash = "sha256-Bv201wqKH9IBLtAfhNBWKpSkYWNxnyHLEctBFrb/tcI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    openssl
    curl
    libxml2
    pcre2
    libevent
    zlib
    sqlite
  ];

  configureFlags = [
    "--enable-agent"
    "--with-openssl=${openssl.dev}"
    "--with-libcurl=${curl.dev}"
    "--with-libxml2=${libxml2.dev}"
    "--with-libpcre2=${pcre2.dev}"
    "--with-sqlite3=${sqlite.dev}"
  ];

  meta = {
    description = "Enterprise-class open source monitoring solution";
    homepage = "https://www.zabbix.com/";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "zabbix_agentd";
  };
})
