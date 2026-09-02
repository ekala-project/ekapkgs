{
  stdenv,
  autoreconfHook,
  makeWrapper,
  pkg-config,

  fetchFromGitHub,

  bison,
  brotli,
  coreutils,
  cunit ? null,
  cyrus_sasl ? null,
  fig2dev,
  flex,
  icu ? null,
  jansson,
  lib,
  libbsd,
  libcap ? null,
  libchardet,
  libical ? null,
  libmysqlclient ? null,
  libpq ? null,
  libsrs2,
  libuuid ? null,
  libxml2,
  nghttp2 ? null,
  openssl,
  pcre2 ? null,
  perl,
  rsync ? null,
  shapelib,
  sqlite ? null,
  unixtools ? null,
  valgrind ? null,
  wslay,
  xapian,
  zlib,

  enableAutoCreate ? true,
  enableBackup ? true,
  enableCalalarmd ? true,
  enableHttp ? true,
  enableIdled ? true,
  enableJMAP ? true,
  enableMurder ? true,
  enableNNTP ? false,
  enableReplication ? true,
  enableSrs ? true,
  enableUnitTests ? true,
  enableXapian ? true,
  withLibcap ? true,
  withMySQL ? false,
  withOpenssl ? true,
  withPgSQL ? false,
  withSQLite ? true,
  withZlib ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cyrus-imapd";
  version = "3.12.3";

  src = fetchFromGitHub {
    owner = "cyrusimap";
    repo = "cyrus-imapd";
    tag = "cyrus-imapd-${finalAttrs.version}";
    hash = "sha256-2HTrFjFlFFqF1TWtClPSOJSCgmomjSgEU7o2UPgd/Cs=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    flex
    perl
    openssl
    zlib
    bison
    libsrs2
    libbsd
    jansson
  ]
  ++ lib.optionals (unixtools != null && unixtools ? xxd) [ unixtools.xxd ]
  ++ lib.optionals (pcre2 != null) [ pcre2 ]
  ++ lib.optionals (valgrind != null) [ valgrind ]
  ++ lib.optionals (fig2dev != null) [ fig2dev ]
  ++ lib.optionals (cyrus_sasl != null) [ cyrus_sasl.dev ]
  ++ lib.optionals (icu != null) [ icu ]
  ++ lib.optionals (libuuid != null) [ libuuid ]
  ++ lib.optionals (libcap != null && stdenv.hostPlatform.isLinux) [ libcap ]
  ++ lib.optionals (enableHttp || enableCalalarmd || enableJMAP) (
    [ shapelib ]
    ++ lib.optionals (brotli != null) [ brotli.dev ]
    ++ lib.optionals (libical != null) [ libical.dev ]
    ++ [ libxml2.dev ]
    ++ lib.optionals (nghttp2 != null) [ nghttp2.dev ]
  )
  ++ lib.optionals enableJMAP ([ libchardet ] ++ [ wslay ])
  ++ lib.optionals enableXapian (lib.optionals (rsync != null) [ rsync ] ++ [ xapian ])
  ++ lib.optionals (withMySQL && libmysqlclient != null) [ libmysqlclient ]
  ++ lib.optionals (withPgSQL && libpq != null) [ libpq ]
  ++ lib.optionals (withSQLite && sqlite != null) [ sqlite ];

  enableParallelBuilding = true;

  postPatch =
    let
      saslLib = if cyrus_sasl != null then cyrus_sasl else openssl;
      sqliteLib = if sqlite != null then sqlite else openssl;
      uuidLib = if libuuid != null then libuuid else openssl;
      pcreLib = if pcre2 != null then pcre2 else openssl;
      managesieveLibs = [
        zlib
        saslLib
        sqliteLib
      ]
      ++ lib.optionals (libuuid != null) [ libuuid ];
      imapLibs = managesieveLibs ++ lib.optionals (pcre2 != null) [ pcre2 ];
      mkLibsString = lib.strings.concatMapStringsSep " " (l: "-L${lib.getLib l}/lib");
    in
    ''
      patchShebangs cunit/*.pl
      patchShebangs imap/promdatagen
      patchShebangs tools/*

      echo ${finalAttrs.version} > VERSION

      substituteInPlace cunit/command.testc \
        --replace-fail /usr/bin/touch ${lib.getExe' coreutils "touch"} \
        --replace-fail /bin/echo ${lib.getExe' coreutils "echo"} \
        --replace-fail /usr/bin/tr ${lib.getExe' coreutils "tr"} \
        --replace-fail /bin/sh ${stdenv.shell}

      substituteInPlace perl/imap/Makefile.PL.in \
        --replace-fail  '"$LIB_SASL' '"${mkLibsString imapLibs} -lpcre2-posix $LIB_SASL'
      substituteInPlace perl/sieve/managesieve/Makefile.PL.in \
        --replace-fail  '"$LIB_SASL' '"${mkLibsString managesieveLibs} $LIB_SASL'
    '';

  postFixup = ''
    wrapProgram $out/bin/cyradm --set PERL5LIB $(find $out/lib/perl5 -type d | tr "\\n" ":")
  '';

  configureFlags = [
    "--with-pidfile=/run/cyrus/master.pid"
    (lib.enableFeature enableAutoCreate "autocreate")
    (lib.enableFeature enableSrs "srs")
    (lib.enableFeature enableIdled "idled")
    (lib.enableFeature enableMurder "murder")
    (lib.enableFeature enableBackup "backup")
    (lib.enableFeature enableReplication "replication")
    (lib.enableFeature enableUnitTests "unit-tests")
    (lib.enableFeature (enableHttp || enableCalalarmd || enableJMAP) "http")
    (lib.enableFeature enableJMAP "jmap")
    (lib.enableFeature enableNNTP "nntp")
    (lib.enableFeature enableXapian "xapian")
    (lib.enableFeature enableCalalarmd "calalarmd")
    (lib.withFeature withZlib "zlib=${zlib}")
    (lib.withFeature withOpenssl "openssl")
    (lib.withFeature withMySQL "mysql")
    (lib.withFeature withPgSQL "pgsql")
  ]
  ++ lib.optionals (libcap != null) [
    (lib.withFeature withLibcap "libcap=${libcap}")
  ]
  ++ lib.optionals (sqlite != null) [
    (lib.withFeature withSQLite "sqlite")
  ];

  checkInputs = lib.optionals (cunit != null) [ cunit ];
  doCheck = true;

  meta = {
    homepage = "https://www.cyrusimap.org";
    description = "Email, contacts and calendar server";
    changelog = "https://www.cyrusimap.org/imap/download/release-notes/${lib.versions.majorMinor finalAttrs.version}/x/${finalAttrs.version}.html";
    license = lib.licenses.bsdOriginal;
    mainProgram = "cyradm";
    platforms = lib.platforms.unix;
  };
})
