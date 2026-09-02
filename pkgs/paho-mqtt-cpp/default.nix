{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  paho-mqtt-c,
  enableStatic ? stdenv.hostPlatform.isStatic,
  enableShared ? !stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "paho.mqtt.cpp";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "eclipse-paho";
    repo = "paho.mqtt.cpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WpuI0BPGPCuV1riviUGy2CLshW0RSVIxcjgFmmH2SqA=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    openssl
    paho-mqtt-c
  ];

  cmakeFlags = [
    (lib.cmakeBool "PAHO_WITH_SSL" true)
    (lib.cmakeBool "PAHO_BUILD_STATIC" enableStatic)
    (lib.cmakeBool "PAHO_BUILD_SHARED" enableShared)
  ];

  meta = {
    description = "Eclipse Paho MQTT C++ Client Library";
    homepage = "https://www.eclipse.org/paho/";
    license = lib.licenses.epl10;
    platforms = lib.platforms.unix;
  };
})
