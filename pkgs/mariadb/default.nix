{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  bison,
  boost,
  cmake,
  flex,
  makeWrapper,
  pkg-config,
  curl,
  libiconv,
  ncurses,
  openssl,
  pcre2,
  libkrb5,
  libaio,
  liburing,
  systemd,
  cctools,
  perl,
  jemalloc,
  less,
  libedit,
  bzip2,
  lz4,
  lzo,
  snappy,
  xz,
  zlib,
  zstd,
  cracklib,
  judy,
  libevent,
  libxml2,
  linux-pam,
  numactl,
  fmt,
  withStorageMroonga ? true,
  kytea,
  libsodium,
  msgpack-cxx,
  zeromq,
  withStorageRocks ? true,
  withEmbedded ? false,
  withNuma ? false,
}:

let
  isCross = stdenv.buildPlatform != stdenv.hostPlatform;

  libExt = stdenv.hostPlatform.extensions.sharedLibrary;

  mytopEnv = buildPackages.perl.withPackages (
    p:
    with p;
    [
      DBI
      TermReadKey
    ]
    ++ lib.optional (p ? DBDMariaDB) p.DBDMariaDB
  );
in

stdenv.mkDerivation (finalAttrs: {
  pname = "mariadb-server";
  version = "11.4.12";

  src = fetchurl {
    url = "https://archive.mariadb.org/mariadb-${finalAttrs.version}/source/mariadb-${finalAttrs.version}.tar.gz";
    hash = "sha256-WreIPbUZv86/3SqsCbxVRKEs4yjznt1G0L8BaQYV72w=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    bison
    boost
    flex
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) makeWrapper;

  buildInputs = [
    libiconv
    ncurses
    zlib
    pcre2
    openssl
    curl
    bzip2
    lz4
    lzo
    snappy
    xz
    zstd
    cracklib
    judy
    libevent
    libxml2
    fmt
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libkrb5
    systemd
    liburing
    linux-pam
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
    perl
    libedit
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    jemalloc
    mytopEnv
  ]
  ++ lib.optional withNuma numactl
  ++ lib.optionals withStorageMroonga [
    kytea
    libsodium
    msgpack-cxx
    zeromq
  ];

  propagatedBuildInputs = lib.optional withNuma numactl;

  prePatch = ''
    sed -i 's,[^"]*/var/log,/var/log,g' storage/mroonga/vendor/groonga/CMakeLists.txt
  '';

  patches = [
    ./cmake-includedir.patch
    ./include-cstdint-full.patch
  ];

  postPatch = ''
    substituteInPlace scripts/galera_new_cluster.sh \
      --replace ":-mariadb" ":-mysql"
  '';

  cmakeEntries = {
    BUILD_CONFIG = "mysql_release";
    MANUFACTURER = "ekapkgs";
    DEFAULT_CHARSET = "utf8mb4";
    DEFAULT_COLLATION = "utf8mb4_unicode_ci";
    SECURITY_HARDENED = true;

    INSTALL_UNIX_ADDRDIR = "/run/mysqld/mysqld.sock";
    INSTALL_BINDIR = "bin";
    INSTALL_DOCDIR = "share/doc/mysql";
    INSTALL_DOCREADMEDIR = "share/doc/mysql";
    INSTALL_INCLUDEDIR = "include/mysql";
    INSTALL_LIBDIR = "lib";
    INSTALL_PLUGINDIR = "lib/mysql/plugin";
    INSTALL_INFODIR = "share/mysql/docs";
    INSTALL_MANDIR = "share/man";
    INSTALL_MYSQLSHAREDIR = "share/mysql";
    INSTALL_SCRIPTDIR = "bin";
    INSTALL_SUPPORTFILESDIR = "share/doc/mysql";
    INSTALL_MYSQLTESTDIR = "OFF";
    INSTALL_SQLBENCHDIR = "OFF";
    INSTALL_PAMDIR = "share/pam/lib/security";
    INSTALL_PAMDATADIR = "share/pam/etc/security";

    WITH_ZLIB = "system";
    WITH_SSL = "system";
    WITH_PCRE = "system";
    WITH_SAFEMALLOC = false;
    WITH_UNIT_TESTS = false;
    EMBEDDED_LIBRARY = false;

    MYSQL_DATADIR = "/var/lib/mysql";
    ENABLED_LOCAL_INFILE = false;
    WITH_READLINE = true;
    WITH_EXTRA_CHARSETS = "all";
    WITH_EMBEDDED_SERVER = withEmbedded;
    WITH_WSREP = true;
    WITH_INNODB_DISALLOW_WRITES = true;
    WITHOUT_EXAMPLE = true;
    WITHOUT_FEDERATED = true;
    WITHOUT_TOKUDB = true;
  };

  cmakeFlags =
    lib.optionals withNuma [
      "-DWITH_NUMA=ON"
    ]
    ++ lib.optionals (!withStorageMroonga) [
      "-DWITHOUT_MROONGA=1"
    ]
    ++ lib.optionals (!withStorageRocks) [
      "-DWITHOUT_ROCKSDB=1"
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin && withStorageRocks) [
      "-DWITH_ROCKSDB_JEMALLOC=ON"
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      "-DWITH_JEMALLOC=yes"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "-DPLUGIN_AUTH_PAM=NO"
      "-DPLUGIN_AUTH_PAM_V1=NO"
      "-DWITHOUT_OQGRAPH=1"
      "-DWITHOUT_PLUGIN_S3=1"
    ]
    ++ lib.optionals isCross [
      "-DSTACK_DIRECTION=-1"
      "-DCMAKE_CROSSCOMPILING_EMULATOR=${stdenv.hostPlatform.emulator buildPackages}"
    ];

  env =
    lib.optionalAttrs stdenv.hostPlatform.isi686 {
      CXXFLAGS = "-fpermissive";
    }
    // lib.optionalAttrs (stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isGnu) {
      NIX_CFLAGS_COMPILE = "-D_LARGEFILE64_SOURCE";
    };

  preConfigure = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    patchShebangs scripts/mytop.sh
  '';

  postInstall =
    lib.optionalString (!withEmbedded) ''
      rm "$out"/lib/mysql/plugin/daemon_example.ini
      rm "$out"/lib/{libmariadb.a,libmariadbclient.a,libmysqlclient.a,libmysqlclient_r.a,libmysqlservices.a}
      rm -f "$out"/bin/{mariadb-config,mariadb_config,mysql_config}
      rm -r $out/include
      rm -r $out/lib/pkgconfig
    ''
    + ''
      rm -r "$out"/share/aclocal
      chmod +x "$out"/bin/wsrep_sst_common
      rm -f "$out"/bin/{mariadb-client-test,mariadb-test,mysql_client_test,mysqltest}
    ''
    + lib.optionalString withStorageMroonga ''
      mv "$out"/share/{groonga,groonga-normalizer-mysql} "$out"/share/doc/mysql
    ''
    + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      mv "$out"/lib/mysql/plugin/test_pam_modules/pam_mariadb_mtr.so "$out"/share/pam/lib/security
    '';

  postFixup = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    wrapProgram $out/bin/mytop --set PATH ${
      lib.makeBinPath [
        less
        ncurses
      ]
    }
  '';

  passthru = {
    # TODO(ekaos): replace with integrationTests
    # tests = { ... };
  };

  meta = {
    description = "Enhanced, drop-in replacement for MySQL";
    mainProgram = "mariadbd";
    homepage = "https://mariadb.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
})
