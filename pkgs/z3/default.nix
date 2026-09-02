{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  cmake,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "z3";
  version = "4.16.0";

  src = fetchFromGitHub {
    owner = "Z3Prover";
    repo = "z3";
    rev = "z3-${finalAttrs.version}";
    hash = "sha256-DnhX3kxggnFmyYwXEPBsBA1rh4oor1oIJR5TMJk/jvc=";
  };

  patches = [
    ./fix-pkg-config-paths.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    python3
    cmake
    cmake.configurePhaseHook
  ];

  enableParallelBuilding = true;

  cmakeFlags = [
    (lib.cmakeBool "Z3_BUILD_PYTHON_BINDINGS" false)
    (lib.cmakeBool "Z3_BUILD_JAVA_BINDINGS" false)
    (lib.cmakeBool "Z3_BUILD_OCAML_BINDINGS" false)
    (lib.cmakeBool "Z3_SINGLE_THREADED" false)
    (lib.cmakeBool "Z3_BUILD_LIBZ3_SHARED" true)
    (lib.cmakeBool "Z3_BUILD_TEST_EXECUTABLES" false)
    (lib.cmakeBool "Z3_ENABLE_EXAMPLE_TARGETS" false)
  ];

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  meta = {
    description = "High-performance theorem prover and SMT solver";
    mainProgram = "z3";
    homepage = "https://github.com/Z3Prover/z3";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
