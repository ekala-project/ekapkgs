{
  lib,
  stdenv,
  fetchurl,
  ncurses,
  which,
  perl,
  gdbm,
  openssl,
  cyrus_sasl,
  gpgme,
  libkrb5,
  zlib,
  headerCache ? true,
  sslSupport ? true,
  saslSupport ? true,
  gpgmeSupport ? true,
  imapSupport ? true,
  pop3Support ? true,
  smtpSupport ? true,
  withSidebar ? true,
  gssSupport ? true,
}:

stdenv.mkDerivation rec {
  pname = "mutt";
  version = "2.4.0";

  outputs = [
    "out"
    "doc"
    "info"
  ];

  src = fetchurl {
    url = "http://ftp.mutt.org/pub/mutt/${pname}-${version}.tar.gz";
    hash = "sha256-j2yi70L48HzcjsOR6KpBpwJJDq5VrHIBawuU3fRK4pI=";
  };

  patches = [
    ./no-build-only-refs.patch
  ];

  enableParallelBuilding = true;
  strictDeps = true;

  nativeBuildInputs = [
    perl
    which
  ];

  buildInputs = [
    ncurses
    zlib
  ]
  ++ lib.optional headerCache gdbm
  ++ lib.optional sslSupport openssl
  ++ lib.optional gssSupport libkrb5
  ++ lib.optional saslSupport cyrus_sasl;

  configureFlags = [
    (lib.enableFeature headerCache "hcache")
    (lib.enableFeature gpgmeSupport "gpgme")
    (lib.enableFeature imapSupport "imap")
    (lib.enableFeature smtpSupport "smtp")
    (lib.enableFeature pop3Support "pop")
    (lib.enableFeature withSidebar "sidebar")
    "--with-mailpath="
    "ac_cv_path_SENDMAIL=sendmail"
    "--enable-debug"
    "--with-homespool=mailbox"
  ]
  ++ lib.optional sslSupport "--with-ssl"
  ++ lib.optional gssSupport "--with-gss"
  ++ lib.optional saslSupport "--with-sasl"
  ++ lib.optional gpgmeSupport "--with-gpgme-prefix=${lib.getDev gpgme}";

  meta = {
    description = "Small but very powerful text-based mail client";
    homepage = "http://www.mutt.org";
    mainProgram = "mutt";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
