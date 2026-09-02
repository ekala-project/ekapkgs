{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rapidjson";
  version = "1.1.0-unstable-2025-02-05";

  src = fetchFromGitHub {
    owner = "Tencent";
    repo = "rapidjson";
    rev = "24b5e7a8b27f42fa16b96fc70aade9106cf7102f";
    hash = "sha256-oHHLYRDMb7Y/k0CwsdsxPC5lglr2IChQi0AiOMiFn78=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [
    (lib.cmakeBool "RAPIDJSON_BUILD_DOC" false)
    (lib.cmakeBool "RAPIDJSON_BUILD_TESTS" false)
    (lib.cmakeBool "RAPIDJSON_BUILD_EXAMPLES" false)
    (lib.cmakeBool "RAPIDJSON_ENABLE_INSTRUMENTATION_OPT" false)
  ];

  meta = {
    description = "Fast JSON parser/generator for C++ with both SAX/DOM style API";
    homepage = "http://rapidjson.org/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
