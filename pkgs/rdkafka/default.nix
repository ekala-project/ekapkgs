{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  zstd,
  openssl,
  curl,
  cyrus_sasl,
  cmake,
  ninja,
  pkg-config,
  deterministic-host-uname,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rdkafka";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "confluentinc";
    repo = "librdkafka";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-WW64fwh0xR4lEVwmrv00tP9mo6b49aCNgLLH/P0YS8k=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    pkg-config
    deterministic-host-uname
  ];

  buildInputs = [
    zlib
    zstd
    openssl
    curl
    cyrus_sasl
  ];

  cmakeFlags = [
    (lib.cmakeBool "RDKAFKA_BUILD_STATIC" stdenv.hostPlatform.isStatic)
    (lib.cmakeBool "RDKAFKA_BUILD_TESTS" (
      !stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isStatic
    ))
    (lib.cmakeBool "RDKAFKA_BUILD_EXAMPLES" (
      !stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isStatic
    ))
    (lib.cmakeFeature "CMAKE_C_FLAGS" "-Wno-error=strict-overflow")
  ];

  postPatch = ''
    patchShebangs .
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Apache Kafka C/C++ client library";
    homepage = "https://github.com/confluentinc/librdkafka";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
