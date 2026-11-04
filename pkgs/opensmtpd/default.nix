{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  autoconf-archive,
  pkg-config,
  libtool,
  bison,
  libevent,
  zlib,
  libressl,
  db,
  pam,
  libxcrypt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opensmtpd";
  version = "7.8.0p0";

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
    libtool
    bison
  ];

  buildInputs = [
    libevent
    zlib
    libressl
    db
    pam
    libxcrypt
  ];

  src = fetchurl {
    url = "https://www.opensmtpd.org/archives/opensmtpd-${finalAttrs.version}.tar.gz";
    hash = "sha256-QDTeLpLGH6g+7a2x2Ni9/mXlfrUM6WeeAUCVDjTKSrc=";
  };

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-mantype=doc"
    "--with-auth-pam"
    "--without-auth-bsdauth"
    "--with-path-socket=/run"
    "--with-path-pidfile=/run"
    "--with-user-smtpd=smtpd"
    "--with-user-queue=smtpq"
    "--with-group-queue=smtpq"
    "--with-path-CAfile=/etc/ssl/certs/ca-certificates.crt"
    "--with-libevent=${libevent.dev}"
    "--with-table-db"
  ];

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  meta = {
    homepage = "https://www.opensmtpd.org/";
    description = "A free implementation of the server-side SMTP protocol as defined by RFC 5321";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
  };
})
