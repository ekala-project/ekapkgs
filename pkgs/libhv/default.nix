{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libhv";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "ithewei";
    repo = "libhv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YIWXdAZsWeSdtPtBaf/t9t68dFKw2nY0bvgMrzCEE5U=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    curl
    openssl
  ];

  cmakeEntries = {
    ENABLE_UDS = true;
    WITH_MQTT = true;
    WITH_CURL = true;
    WITH_NGHTTP2 = true;
    WITH_OPENSSL = true;
    WITH_KCP = true;
  };

  meta = {
    description = "C/c++ network library for developing TCP/UDP/SSL/HTTP/WebSocket/MQTT client/server";
    homepage = "https://github.com/ithewei/libhv";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
