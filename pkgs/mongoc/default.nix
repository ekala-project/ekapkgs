{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  openssl,
  zlib,
  zstd,
  icu,
  cyrus_sasl,
  snappy,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mongoc";
  version = "1.30.9";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongo-c-driver";
    tag = finalAttrs.version;
    hash = "sha256-5msXPEt4a/Q/LDSowf2Eu2HD7ktrTrB9Adi/PtPIs5o=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    openssl
    zlib
    zstd
    icu
    cyrus_sasl
    snappy
  ];

  cmakeEntries = {
    BUILD_VERSION = finalAttrs.version;
    ENABLE_UNINSTALL = false;
    ENABLE_AUTOMATIC_INIT_AND_CLEANUP = false;
    CMAKE_INSTALL_LIBDIR = "lib";
  };

  # remove forbidden reference to $TMPDIR
  preFixup = ''
    rm -rf src/{libmongoc,libbson}
  '';

  meta = {
    description = "Official C client library for MongoDB";
    homepage = "http://mongoc.org";
    license = lib.licenses.asl20;
    mainProgram = "mongoc-stat";
    platforms = lib.platforms.all;
  };
})
