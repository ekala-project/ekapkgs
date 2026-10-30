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

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "confluentinc";
    repo = "librdkafka";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WW64fwh0xR4lEVwmrv00tP9mo6b49aCNgLLH/P0YS8k=";
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

  cmakeEntries = {
    RDKAFKA_BUILD_STATIC = stdenv.hostPlatform.isStatic;
    RDKAFKA_BUILD_TESTS = !stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isStatic;
    RDKAFKA_BUILD_EXAMPLES = !stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isStatic;
  };

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_C_FLAGS" "-Wno-error=strict-overflow")
  ];

  postPatch = ''
    patchShebangs .
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isStatic ''
    for pc in rdkafka{,++}; do
      ln -s $dev/lib/pkgconfig/$pc{-static,}.pc
    done
  '';

  meta = {
    description = "Apache Kafka C/C++ client library";
    homepage = "https://github.com/confluentinc/librdkafka";
    changelog = "https://github.com/confluentinc/librdkafka/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
