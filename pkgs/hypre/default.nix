{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gfortran,
  blas,
  lapack,
  mpi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hypre";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "hypre-space";
    repo = "hypre";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zu9YWfBT2WJxPg6JHrXjZWRM9Ai1p28EpvAx6xfdPsY=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    mpi
    pkg-config
    gfortran
  ];

  propagatedBuildInputs = [
    blas
    lapack
    mpi
  ];

  cmakeDir = "../src";

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "BLA_PREFER_PKGCONFIG" true)
    (lib.cmakeBool "HYPRE_ENABLE_HYPRE_BLAS" false)
    (lib.cmakeBool "HYPRE_ENABLE_HYPRE_LAPACK" false)
    (lib.cmakeBool "HYPRE_ENABLE_FORTRAN" true)
    (lib.cmakeBool "HYPRE_ENABLE_OPENMP" true)
    (lib.cmakeBool "HYPRE_ENABLE_MPI" true)
    (lib.cmakeBool "HYPRE_BUILD_TESTS" false)
  ];

  meta = {
    description = "Parallel solvers for sparse linear systems featuring multigrid methods";
    homepage = "https://computing.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods";
    platforms = lib.platforms.unix;
    license = with lib.licenses; [
      asl20
      mit
    ];
    broken = true; # cmake FindMPI fails to locate MPI compilers
  };
})
