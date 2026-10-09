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
  withJdbc ? false,
  withOdbc ? false,
}:

let
  versions = lib.importJSON ./versions.json;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "duckdb";
  inherit (versions) rev version;

  src = fetchFromGitHub {
    inherit (versions) hash;
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

  cmakeFlags = [
    (lib.cmakeFeature "DUCKDB_EXTENSION_CONFIGS" "${finalAttrs.src}/.github/config/in_tree_extensions.cmake")
    (lib.cmakeBool "BUILD_ODBC_DRIVER" withOdbc)
    (lib.cmakeBool "JDBC_DRIVER" withJdbc)
    (lib.cmakeFeature "OVERRIDE_GIT_DESCRIBE" "v${finalAttrs.version}-0-g${finalAttrs.rev}")
    (lib.cmakeBool "BUILD_UNITTESTS" false)
  ];

  meta = {
    changelog = "https://github.com/duckdb/duckdb/releases/tag/v${finalAttrs.version}";
    description = "Embeddable SQL OLAP Database Management System";
    homepage = "https://duckdb.org/";
    license = lib.licenses.mit;
    mainProgram = "duckdb";
    platforms = lib.platforms.all;
  };
})
