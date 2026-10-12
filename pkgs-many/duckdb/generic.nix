{
  version,
  src-hash,
  withJdbc ? false,
  withOdbc ? false,
  mkVariantPassthru,
  ...
}@variantArgs:

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  openssl,
  java,
  python3,
  unixODBC,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "duckdb";
  inherit version;

  src = fetchFromGitHub {
    hash = src-hash;
    owner = "duckdb";
    repo = "duckdb";
    tag = "v${finalAttrs.version}";
  };

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    python3
  ];
  buildInputs = [
    openssl
  ]
  ++ lib.optionals withJdbc [ java.v11 ]
  ++ lib.optionals withOdbc [ unixODBC ];

  extensions = lib.optionals withJdbc [ "jdbc" ] ++ lib.optionals withOdbc [ "odbc" ];

  cmakeEntries = {
    DUCKDB_EXTENSION_CONFIGS = "${finalAttrs.src}/.github/config/in_tree_extensions.cmake";
    BUILD_ODBC_DRIVER = withOdbc;
    JDBC_DRIVER = withJdbc;
    OVERRIDE_GIT_DESCRIBE = "v${finalAttrs.version}";
    BUILD_UNITTESTS = false;
  };

  passthru = mkVariantPassthru variantArgs;

  meta = {
    changelog = "https://github.com/duckdb/duckdb/releases/tag/v${finalAttrs.version}";
    description = "Embeddable SQL OLAP Database Management System";
    homepage = "https://duckdb.org/";
    license = lib.licenses.mit;
    mainProgram = "duckdb";
    platforms = lib.platforms.all;
  };
})
