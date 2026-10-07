{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  mbedtlsSupport ? true,
  mbedtls,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nng";
  version = "1.12.3";

  src = fetchFromGitHub {
    owner = "nanomsg";
    repo = "nng";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WumCZ7Qx/ArKX5GOu7kpc0TCbqQMn1o+BKksBvfSRw8=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
  ]
  ++ lib.optionals mbedtlsSupport [ mbedtls ];

  buildInputs = lib.optionals mbedtlsSupport [ mbedtls ];

  cmakeFlags = [
    "-G Ninja"
  ];

  cmakeEntries = {
    BUILD_SHARED_LIBS = (!stdenv.hostPlatform.isStatic);
  }
  // lib.optionalAttrs mbedtlsSupport {
    MBEDTLS_ROOT_DIR = "${mbedtls}";
    NNG_ENABLE_TLS = true;
  };

  meta = {
    homepage = "https://nng.nanomsg.org/";
    description = "Nanomsg next generation";
    license = lib.licenses.mit;
    mainProgram = "nngcat";
    platforms = lib.platforms.unix;
  };
})
