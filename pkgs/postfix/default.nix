{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  makeWrapper,
  gnused,
  db,
  openssl,
  cyrus_sasl,
  libnsl,
  lmdb,
  coreutils,
  findutils,
  gnugrep,
  gawk,
  icu,
  pcre2,
  m4,
  withLDAP ? true,
  openldap,
  withTLSRPT ? true,
  libtlsrpt,
}:

let
  ccargs = lib.concatStringsSep " " (
    [
      "-DUSE_TLS"
      "-DUSE_SASL_AUTH"
      "-DUSE_CYRUS_SASL"
      "-I${cyrus_sasl.dev}/include/sasl"
      "-DHAS_DB_BYPASS_MAKEDEFS_CHECK"
      "-DHAS_LMDB"
      "-std=gnu17"
    ]
    ++ lib.optionals withLDAP [
      "-DHAS_LDAP"
      "-DUSE_LDAP_SASL"
    ]
    ++ lib.optional withTLSRPT "-DUSE_TLSRPT"
  );
  auxlibs = lib.concatStringsSep " " (
    [
      "-lcrypto"
      "-ldb"
      "-llmdb"
      "-lnsl"
      "-lresolv"
      "-lsasl2"
      "-lssl"
    ]
    ++ lib.optional withLDAP "-lldap"
    ++ lib.optional withTLSRPT "-ltlsrpt"
  );

in
stdenv.mkDerivation (finalAttrs: {
  pname = "postfix";
  version = "3.11.4";

  src = fetchurl {
    url = "http://ftp.porcupine.org/mirrors/postfix-release/official/postfix-${finalAttrs.version}.tar.gz";
    hash = "sha256-Im7FmhjkPid2kQBeMUlvdgi5upIQvmAKJn+yF6Smzuk=";
  };

  nativeBuildInputs = [
    makeWrapper
    m4
  ];
  buildInputs = [
    cyrus_sasl
    db
    icu
    libnsl
    lmdb
    openssl
    pcre2
  ]
  ++ lib.optional withLDAP openldap
  ++ lib.optional withTLSRPT libtlsrpt;

  hardeningDisable = [ "format" ];

  patches = [
    ./postfix-script-shell.patch
    ./post-install-script.patch
    ./postfix-3.0-no-warnings.patch
    ./relative-symlinks.patch
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/postfix/raw/2f9d42453e67ebc43f786d98262a249037f80a77/f/postfix-3.6.2-glibc-234-build-fix.patch";
      sha256 = "sha256-xRUL5gaoIt6HagGlhsGwvwrAfYvzMgydsltYMWvl9BI=";
    })
  ];

  postPatch = ''
    sed -e '/^PATH=/d' -i postfix-install
    sed -e "s|@PACKAGE@|$out|" -i conf/post-install
    sed -e "s|@NIX_STORE@|$NIX_STORE|" -i conf/post-install
  '';

  postConfigure = ''
    export command_directory=$out/sbin
    export config_directory=/etc/postfix
    export meta_directory=$out/etc/postfix
    export daemon_directory=$out/libexec/postfix
    export data_directory=/var/lib/postfix/data
    export html_directory=$out/share/postfix/doc/html
    export mailq_path=$out/bin/mailq
    export manpage_directory=$out/share/man
    export newaliases_path=$out/bin/newaliases
    export queue_directory=/var/lib/postfix/queue
    export readme_directory=$out/share/postfix/doc
    export sendmail_path=$out/bin/sendmail

    makeFlagsArray+=(AR=$AR _AR=$AR RANLIB=$RANLIB _RANLIB=$RANLIB)

    make makefiles CCARGS='${ccargs}' AUXLIBS='${auxlibs}'
  '';

  enableParallelBuilding = true;

  env = lib.optionalAttrs withLDAP {
    NIX_LDFLAGS = "-llber";
  };

  installTargets = [ "non-interactive-package" ];

  installFlags = [ "install_root=installdir" ];

  postInstall = ''
    mkdir -p $out
    mv -v installdir/$out/* $out/
    cp -rv installdir/etc $out
    sed -e '/^PATH=/d' -i $out/libexec/postfix/post-install
    wrapProgram $out/libexec/postfix/post-install \
      --prefix PATH ":" ${
        lib.makeBinPath [
          coreutils
          findutils
          gnugrep
        ]
      }
    wrapProgram $out/libexec/postfix/postfix-script \
      --prefix PATH ":" ${
        lib.makeBinPath [
          coreutils
          findutils
          gnugrep
          gawk
          gnused
        ]
      }

    sed -e "s|$NIX_STORE/[a-z0-9]\{32\}-|$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-|g" -i $out/etc/postfix/makedefs.out
  '';

  meta = {
    homepage = "http://www.postfix.org/";
    changelog = "https://www.postfix.org/announcements/postfix-${finalAttrs.version}.html";
    description = "Fast, easy to administer, and secure mail server";
    license = with lib.licenses; [
      ipl10
      epl20
    ];
    platforms = lib.platforms.linux;
  };
})
