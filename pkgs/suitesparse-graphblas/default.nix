{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  m4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "suitesparse-graphblas";
  version = "10.5.3";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "DrTimothyAldenDavis";
    repo = "GraphBLAS";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s59DgzCCCfuBpiyW1MuHYdjLvdEj8AQfPrdz6LxeCKc=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    m4
  ];

  preConfigure = ''
    export HOME=$(mktemp -d)
  '';

  cmakeEntries = {
    GRAPHBLAS_USE_JIT = !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
  };

  meta = {
    description = "Graph algorithms in the language of linear algebra";
    homepage = "https://people.engr.tamu.edu/davis/GraphBLAS.html";
    license = lib.licenses.asl20;
    platforms = with lib.platforms; unix;
  };
})
