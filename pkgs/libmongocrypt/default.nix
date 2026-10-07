{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  mongoc,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmongocrypt";
  version = "1.20.4";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "libmongocrypt";
    rev = finalAttrs.version;
    hash = "sha256-u8g/ITw1nro4RVi+2aFfXAorUEPasOuptIBUFmw+hDc=";
  };

  patches = [
    # fix pkg-config files
    # submitted upstream: https://github.com/mongodb/libmongocrypt/pull/634
    (fetchpatch {
      url = "https://github.com/mongodb/libmongocrypt/commit/5514cf0a366c4d0dc1b0f2a62201f0f1161054da.diff";
      hash = "sha256-eMSn6MRnc3yKfU2u/Bg3juWiupDzY1DUGi1/HSRftIs=";
    })
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    mongoc
    openssl
  ];

  cmakeEntries = {
    USE_SHARED_LIBBSON = true;
    MONGOCRYPT_MONGOC_DIR = "USE-SYSTEM";
    ENABLE_ONLINE_TESTS = false;
    MONGOCRYPT_ENABLE_DECIMAL128 = false;
    BUILD_VERSION = "${finalAttrs.version}";
  };

  meta = {
    description = "Required C library for client-side and queryable encryption in MongoDB";
    homepage = "https://github.com/mongodb/libmongocrypt";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
})
