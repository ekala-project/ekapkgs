{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "flatbuffers";
  version = "25.12.19";

  src = fetchFromGitHub {
    owner = "google";
    repo = "flatbuffers";
    tag = "v${version}";
    hash = "sha256-I4PthsQOOV8tsi5uRYudyqBPcbE+ZH8Q9j0Ms4HP9Ec=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    python3
  ];

  cmakeFlags = [
    "-DFLATBUFFERS_BUILD_TESTS=${if doCheck then "ON" else "OFF"}"
    "-DFLATBUFFERS_OSX_BUILD_UNIVERSAL=OFF"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  checkTarget = "test";

  meta = {
    description = "Memory Efficient Serialization Library";
    homepage = "https://google.github.io/flatbuffers/";
    license = lib.licenses.asl20;
    mainProgram = "flatc";
    platforms = lib.platforms.unix;
  };
}
