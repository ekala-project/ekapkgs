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

stdenv.mkDerivation rec {
  pname = "mongoc";
  version = "2.5.5";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongo-c-driver";
    tag = version;
    hash = "sha256-FO3DltAwJ3LVYmJx+3wo5y3NR8Lex7bFfttahBVrIlA=";
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
    BUILD_VERSION = "${version}";
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
}
