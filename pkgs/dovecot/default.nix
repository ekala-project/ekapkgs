{
  stdenv,
  lib,
  fetchurl,
  flex,
  bison,
  perl,
  pkg-config,
  systemd,
  openssl,
  bzip2,
  lz4,
  zlib,
  zstd,
  xz,
  inotify-tools,
  pam,
  libcap,
  coreutils,
  clucene-core,
  icu,
  libsodium,
  libstemmer,
  cyrus_sasl,
  fetchpatch,
  rpcsvc-proto,
  libtirpc,
  withLDAP ? true,
  openldap,
  withSQLite ? true,
  sqlite,
}:

stdenv.mkDerivation rec {
  pname = "dovecot";
  version = "2.3.21.1";

  nativeBuildInputs = [
    flex
    bison
    perl
    pkg-config
    rpcsvc-proto
  ];

  buildInputs = [
    openssl
    bzip2
    lz4
    zlib
    zstd
    xz
    clucene-core
    icu
    libsodium
    libstemmer
    cyrus_sasl.dev
    systemd
    pam
    libcap
    inotify-tools
    libtirpc
  ]
  ++ lib.optional withLDAP openldap
  ++ lib.optional withSQLite sqlite;

  src = fetchurl {
    url = "https://dovecot.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.gz";
    hash = "sha256-LZCheMQpdhEIi/farlSSo7w9WrYyjDoDLrQl0sJJCX4=";
  };

  enableParallelBuilding = true;

  env.NIX_LDFLAGS = "-licuuc -licui18n -licudata";

  postPatch = ''
    sed -i -E \
      -e 's!/bin/sh\b!${stdenv.shell}!g' \
      -e 's!([^[:alnum:]/_-])/bin/([[:alnum:]]+)\b!\1${coreutils}/bin/\2!g' \
      -e 's!([^[:alnum:]/_-])(head|sleep|cat)\b!\1${coreutils}/bin/\2!g' \
      src/lib-program-client/test-program-client-local.c

    patchShebangs src/lib-smtp/test-bin/*.sh
    sed -i -s -E 's!\bcat\b!${coreutils}/bin/cat!g' src/lib-smtp/test-bin/*.sh

    patchShebangs src/config/settings-get.pl

    # DES-encrypted passwords are not supported by NixPkgs anymore
    sed '/test_password_scheme("CRYPT"/d' -i src/auth/test-libpassword.c

    export systemdsystemunitdir=$out/etc/systemd/system
  '';

  installFlags = [ "DESTDIR=$(out)" ];

  postInstall = ''
    cp -r $out/$out/* $out
    rm -rf $out/$(echo "$out" | cut -d "/" -f2)
  '';

  patches = [
    ./load-extended-modules.patch
    (fetchpatch {
      url = "https://salsa.debian.org/debian/dovecot/-/raw/debian/1%252.3.19.1+dfsg1-2/debian/patches/Support-openssl-3.0.patch";
      hash = "sha256-PbBB1jIY3jIC8Js1NY93zkV0gISGUq7Nc67Ul5tN7sw=";
    })
  ];

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--with-moduledir=${placeholder "out"}/lib/dovecot/modules"
    "--with-ssl=openssl"
    "--with-zlib"
    "--with-bzlib"
    "--with-lz4"
    "--with-lucene"
    "--with-icu"
    "--with-systemd"
  ]
  ++ lib.optional withLDAP "--with-ldap"
  ++ lib.optional withSQLite "--with-sqlite";

  doCheck = true;

  meta = {
    homepage = "https://dovecot.org/";
    description = "Open source IMAP and POP3 email server written with security primarily in mind";
    license = with lib.licenses; [
      mit
      publicDomain
      lgpl21Only
      bsd3
      bsdOriginal
    ];
    mainProgram = "dovecot";
    platforms = lib.platforms.linux;
  };
}
