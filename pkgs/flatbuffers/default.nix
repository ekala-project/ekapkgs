{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "flatbuffers";
  version = "25.12.19-2026-02-06-03fffb2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "flatbuffers";
    tag = "v${version}";
    hash = "sha256-Q7yy5FwBwmPde8PHLHQkBoPqnVNPrasbomjoyPcPzkc=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    python3
  ];

  cmakeEntries = {
    FLATBUFFERS_BUILD_TESTS = doCheck;
    FLATBUFFERS_OSX_BUILD_UNIVERSAL = false;
  };

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
