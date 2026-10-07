{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "simdjson";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "simdjson";
    repo = "simdjson";
    tag = "v${finalAttrs.version}";
    hash = "sha256-08ge7ZstT0mJczsFoahzxK3dtEFRdPXpJtJLFj5uVVA=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  # Workaround: simdjson's CMakeLists.txt has a multiline project() call
  # which the cmake hook's parseShareDocName regex can't parse, causing
  # a grep failure that kills the build with set -e + inherit_errexit.
  shareDocName = "simdjson";

  cmakeEntries = {
    SIMDJSON_DEVELOPER_MODE = false;
  };

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  meta = {
    homepage = "https://simdjson.org/";
    description = "Parsing gigabytes of JSON per second";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
})
