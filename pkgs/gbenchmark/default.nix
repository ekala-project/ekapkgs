{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gbenchmark";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "v${finalAttrs.version}";
    hash = "sha256-P7wJcKkIBoWtN9FCRticpBzYbEZPq71a0iW/2oDTZRU=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [ gtest ];

  cmakeFlags = [
    (lib.cmakeBool "BENCHMARK_USE_BUNDLED_GTEST" false)
    (lib.cmakeBool "BENCHMARK_ENABLE_WERROR" false)
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-c++17-attribute-extensions";

  doCheck = stdenv.hostPlatform.is64bit;

  meta = {
    description = "Microbenchmark support library";
    homepage = "https://github.com/google/benchmark";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [ ];
  };
})
