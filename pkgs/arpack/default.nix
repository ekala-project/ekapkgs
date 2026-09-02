{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  gfortran,
  blas,
  lapack,
  eigen,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "arpack";
  version = "3.9.1";

  src = fetchFromGitHub {
    owner = "opencollab";
    repo = "arpack-ng";
    tag = finalAttrs.version;
    sha256 = "sha256-HCvapLba8oLqx9I5+KDAU0s/dTmdWOEilS75i4gyfC0=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    gfortran
    ninja
  ];

  buildInputs = [
    eigen
    blas
    lapack
  ];

  doCheck = true;
  enableParallelChecking = false;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "EIGEN" true)
    (lib.cmakeBool "EXAMPLES" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "ICB" true)
    (lib.cmakeBool "INTERFACE64" blas.isILP64)
    (lib.cmakeBool "MPI" false)
    (lib.cmakeBool "TESTS" finalAttrs.finalPackage.doCheck)
  ];

  meta = {
    homepage = "https://github.com/opencollab/arpack-ng";
    description = "A collection of Fortran77 subroutines to solve large scale eigenvalue problems";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
