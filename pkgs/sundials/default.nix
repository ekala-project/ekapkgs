{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gfortran,
  python3,
  blas,
  lapack,
  suitesparse,
  lapackSupport ? true,
  kluSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sundials";
  version = "7.6.0";

  outputs = [
    "out"
    "examples"
  ];

  src = fetchFromGitHub {
    owner = "LLNL";
    repo = "sundials";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DdVZXFfQXpJ9z5ikaK1ZQ/ZkL/vAGdlNsE9MJsIkLdM=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    gfortran
  ];

  buildInputs = [
    python3
  ]
  ++ lib.optionals lapackSupport (
    assert (blas.isILP64 == lapack.isILP64);
    [
      blas
      lapack
    ]
  )
  ++ lib.optionals kluSupport [
    suitesparse
  ];

  cmakeFlags = [
    (lib.cmakeFeature "EXAMPLES_INSTALL_PATH" "${placeholder "examples"}/share/examples")
  ]
  ++ lib.optionals lapackSupport [
    (lib.cmakeBool "ENABLE_LAPACK" true)
    (lib.cmakeFeature "LAPACK_LIBRARIES" "${lapack}/lib/liblapack${stdenv.hostPlatform.extensions.sharedLibrary}")
  ]
  ++ lib.optionals kluSupport [
    (lib.cmakeBool "ENABLE_KLU" true)
    (lib.cmakeFeature "KLU_INCLUDE_DIR" "${lib.getDev suitesparse}/include")
    (lib.cmakeFeature "KLU_LIBRARY_DIR" "${suitesparse}/lib")
  ]
  ++ [
    (lib.cmakeFeature "SUNDIALS_INDEX_SIZE" (toString (if blas.isILP64 then 64 else 32)))
  ];

  doCheck = true;
  checkTarget = "test";

  meta = {
    description = "Suite of nonlinear differential/algebraic equation solvers";
    homepage = "https://computing.llnl.gov/projects/sundials";
    downloadPage = "https://github.com/LLNL/sundials";
    changelog = "https://github.com/LLNL/sundials/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.all;
    maintainers = [ ];
    license = lib.licenses.bsd3;
  };
})
