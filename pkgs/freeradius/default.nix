{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  bsd-finger ? null,
  perl,
  talloc,
  linkOpenssl ? true,
  openssl,
  withCap ? true,
  libcap,
  withCollectd ? false,
  collectd ? null,
  withJson ? false,
  json_c ? null,
  withLdap ? true,
  openldap,
  withMemcached ? false,
  libmemcached ? null,
  withMysql ? false,
  libmysqlclient ? null,
  withPostgresql ? false,
  libpq ? null,
  withPcap ? true,
  libpcap,
  withRedis ? false,
  hiredis ? null,
  withRest ? false,
  curl,
  withSqlite ? true,
  sqlite,
  withYubikey ? false,
  libyubikey ? null,
}:

assert withRest -> withJson;

stdenv.mkDerivation rec {
  pname = "freeradius";
  version = "3.2.10";

  src = fetchFromGitHub {
    owner = "FreeRADIUS";
    repo = "freeradius-server";
    tag = "release_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-+pFV6dDnL7T5G309cLACa+/0vGppCEdk3ghOQhgSjTs=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    openssl
    talloc
    perl
  ]
  ++ lib.optional (bsd-finger != null) bsd-finger
  ++ lib.optional withCap libcap
  ++ lib.optional (withCollectd && collectd != null) collectd
  ++ lib.optional (withJson && json_c != null) json_c
  ++ lib.optional withLdap openldap
  ++ lib.optional (withMemcached && libmemcached != null) libmemcached
  ++ lib.optional (withMysql && libmysqlclient != null) libmysqlclient
  ++ lib.optional (withPostgresql && libpq != null) libpq
  ++ lib.optional withPcap libpcap
  ++ lib.optional (withRedis && hiredis != null) hiredis
  ++ lib.optional withRest curl
  ++ lib.optional withSqlite sqlite
  ++ lib.optional (withYubikey && libyubikey != null) libyubikey;

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ]
  ++ lib.optional (!linkOpenssl) "--with-openssl=no";

  postPatch = lib.optionalString (bsd-finger != null) ''
    substituteInPlace src/main/checkrad.in \
      --replace "/usr/bin/finger" "${bsd-finger}/bin/finger"
  '';

  makeFlags = [ "LOCAL_CERT_FILES=" ];

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
    "INSTALL_CERT_FILES="
  ];

  outputs = [
    "out"
    "dev"
    "man"
    "doc"
  ];

  meta = {
    homepage = "https://freeradius.org/";
    description = "Modular, high performance free RADIUS suite";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
