{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  curl,
  geoip,
  libmaxminddb,
  libxml2,
  lmdb,
  lua,
  pcre2,
  ssdeep,
  yajl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "modsecurity";
  version = "3.0.14";

  src = fetchFromGitHub {
    owner = "SpiderLabs";
    repo = "ModSecurity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SaeBO3+WvPhHiJoiOmijB0G3/QYxjAdxgeCVqESS+4U=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    curl
    geoip
    libmaxminddb
    libxml2
    lmdb
    lua
    pcre2
    ssdeep
    yajl
  ];

  configureFlags = [
    "--with-curl=${curl.dev}"
    "--with-libxml=${libxml2.dev}"
    "--with-pcre2=${pcre2.dev}"
    "--with-lmdb=${lmdb}"
    "--with-yajl=${yajl}"
    "--with-ssdeep=${ssdeep}"
    "--with-geoip=${geoip}"
    "--with-maxmind=${libmaxminddb}"
  ];

  meta = {
    description = "Open source, cross-platform web application firewall engine";
    homepage = "https://www.modsecurity.org/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
})
