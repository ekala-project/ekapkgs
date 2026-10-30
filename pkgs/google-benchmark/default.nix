{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  ninja,
  gtest,
  glibcLocales,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gbenchmark";
  version = "1.9.5";

  src = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Mm4pG7zMB00iof32CxreoNBFnduPZTMp3reHMCIAFPQ=";
  };

  patches = [
    (fetchpatch {
      name = "portability.patch";
      url = "https://github.com/google/benchmark/commit/b5ba9bab85d80f29a161dd634b7d234cf3722f90.patch";
      hash = "sha256-/X01AWXK0eJ59F8oSREZ7V5Cpw1y35n9uFB1mCvMOus=";
    })
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
  ];

  buildInputs = [ gtest ];

  nativeCheckInputs = lib.optionals (glibcLocales != null) [ glibcLocales ];

  strictDeps = true;

  cmakeEntries = {
    BENCHMARK_USE_BUNDLED_GTEST = false;
    BENCHMARK_ENABLE_WERROR = false;
  };

  env = {
    NIX_CFLAGS_COMPILE = lib.join " " (
      lib.optional stdenv.cc.isClang "-Wno-error=c2y-extensions"
      ++ lib.optional stdenv.cc.isClang "-Wno-c++17-attribute-extensions"
    );
  }
  // lib.optionalAttrs stdenv.hostPlatform.isGnu {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  }
  // lib.optionalAttrs (glibcLocales != null) {
    LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";
  };

  doCheck = stdenv.hostPlatform.is64bit;

  meta = {
    description = "Microbenchmark support library";
    homepage = "https://github.com/google/benchmark";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
