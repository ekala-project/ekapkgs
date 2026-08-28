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

let
  inherit (lib) cmakeFeature;
  cmakeBool' = feature: condition: cmakeFeature feature (if condition then "ON" else "OFF");
in

stdenv.mkDerivation (finalAttrs: {
  pname = "rspamd";
  version = "4.1.5";

  src = fetchFromGitHub {
    owner = "rspamd";
    repo = "rspamd";
    tag = finalAttrs.version;
    hash = "sha256-2Sazb+7dC+d/biypU8PSJJ1v3detQy07wvKaPxwT4Zk=";
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

  cmakeFlags = [
    (cmakeFeature "RUNDIR" "/run/rspamd")
    (cmakeFeature "DBDIR" "/var/lib/rspamd")
    (cmakeFeature "LOGDIR" "/var/log/rspamd")
    (cmakeFeature "LOCAL_CONFDIR" "/etc/rspamd")
    (cmakeBool' "ENABLE_BLAS" withBlas)
    (cmakeBool' "ENABLE_HYPERSCAN" (vectorscan != null))
    (cmakeBool' "ENABLE_JEMALLOC" true)
    (cmakeBool' "ENABLE_LUAJIT" withLuaJIT)
    (cmakeBool' "ENABLE_PCRE2" true)
    (cmakeBool' "SYSTEM_DOCTEST" false)
    (cmakeBool' "SYSTEM_XXHASH" true)
    (cmakeBool' "SYSTEM_ZSTD" true)
  ];

  meta = {
    changelog = "https://github.com/rspamd/rspamd/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://rspamd.com";
    license = lib.licenses.asl20;
    description = "Advanced spam filtering system";
    mainProgram = "rspamd";
    platforms = with lib.platforms; linux;
  };
})
