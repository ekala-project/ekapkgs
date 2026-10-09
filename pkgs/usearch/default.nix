{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "usearch";
  version = "2.26.4";

  src = fetchFromGitHub {
    owner = "unum-cloud";
    repo = "usearch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6WMtfSH5FYRYfM2wQ1XudK5h0CDZmikQOJ+91cF0d3M=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [
    (lib.cmakeBool "USEARCH_INSTALL" true)
    (lib.cmakeBool "USEARCH_BUILD_LIB_C" true)
    (lib.cmakeBool "USEARCH_BUILD_TEST_CPP" false)
    (lib.cmakeBool "USEARCH_BUILD_BENCH_CPP" false)
  ];

  postInstall = ''
    install -Dm755 libusearch_c.so -t $out/lib
    install -Dm644 libusearch_static_c.a -t $out/lib
    install -Dm644 ${finalAttrs.src}/c/usearch.h -t $out/include
  '';

  meta = {
    description = "Fastest search engine for vectors, with bindings for 10+ languages";
    homepage = "https://github.com/unum-cloud/usearch";
    changelog = "https://github.com/unum-cloud/usearch/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
})
