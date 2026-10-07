{
  stdenv,
  lib,
  fetchFromGitHub,

  # build
  cmake,
  glib,
  perl,
  pkg-config,

  # runtime
  blas ? null,
  fmt,
  icu,
  jemalloc,
  lapack ? null,
  libarchive,
  libsodium,
  lua,
  luajit ? null,
  openssl,
  pcre2,
  ragel,
  sqlite,
  vectorscan ? null,
  xxhash,
  zstd,

  # flags
  withBlas ? false,
  withLuaJIT ? (luajit != null),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rspamd";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "rspamd";
    repo = "rspamd";
    tag = finalAttrs.version;
    hash = "sha256-ggPK7F2nnWignJvyTMaFVppUbrVVrKorux0yQAD4usQ=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    perl
    ragel
  ];

  buildInputs = [
    fmt
    glib
    icu
    jemalloc
    libarchive
    libsodium
    (if withLuaJIT then luajit else lua)
    openssl
    pcre2
    ragel
    sqlite
    xxhash
    zstd
  ]
  ++ lib.optionals (vectorscan != null) [ vectorscan ]
  ++ lib.optionals withBlas (
    lib.filter (x: x != null) [
      blas
      lapack
    ]
  );

  cmakeEntries = {
    RUNDIR = "/run/rspamd";
    DBDIR = "/var/lib/rspamd";
    LOGDIR = "/var/log/rspamd";
    LOCAL_CONFDIR = "/etc/rspamd";
    ENABLE_BLAS = withBlas;
    ENABLE_HYPERSCAN = (vectorscan != null);
    ENABLE_JEMALLOC = true;
    ENABLE_LUAJIT = withLuaJIT;
    ENABLE_PCRE2 = true;
    SYSTEM_DOCTEST = false;
    SYSTEM_XXHASH = true;
    SYSTEM_ZSTD = true;
  };

  meta = {
    changelog = "https://github.com/rspamd/rspamd/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://rspamd.com";
    license = lib.licenses.asl20;
    description = "Advanced spam filtering system";
    mainProgram = "rspamd";
    platforms = with lib.platforms; linux;
  };
})
